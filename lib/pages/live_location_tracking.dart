import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_13/services/constants.dart';
import 'package:location/location.dart';

class LiveLocationTracking extends StatefulWidget {
  const LiveLocationTracking({super.key});

  @override
  State<LiveLocationTracking> createState() => _LiveLocationTrackingState();
}

class _LiveLocationTrackingState extends State<LiveLocationTracking> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.3738837, 46.3756437);
  static const LatLng destination = LatLng(37.3787537, 46.3738837);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currenticon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((loc) {
      setState(() {
        currentLocation = loc;
      });
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
            zoom: 15,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    getCustomMarkerIcon();
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  /// Fetch the polyline points between the source and destination
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Replace with your Google Maps API Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      });
    }
  }

  void getCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/mostafa.png',
    ).then((icon) {
      setState(() {
        currenticon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: currentLocation == null
          ? const Center(child: Text('Loading'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 15,
              ),
              onMapCreated: (controller) => _controller.complete(controller),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: polylineCoordinates,
                  color: Colors.red,
                  width: 5,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId('source'),
                  position: sourceLocation,
                  icon: sourceIcon,
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destination,
                  icon: destinationIcon,
                ),
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: currenticon,
                  position: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                ),
              },
            ),
    );
  }
}
