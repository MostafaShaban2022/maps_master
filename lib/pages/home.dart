import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng myCurrentLocation = const LatLng(26.8206, 30.8025);

  Set<Polygon> polygons = {
    Polygon(
      polygonId: const PolygonId('areal'),
      points: const [
        LatLng(30.0444, 31.2357),
        LatLng(30.0490, 31.2400),
        LatLng(30.0450, 31.2450),
        LatLng(30.0400, 31.2400),
      ],
      fillColor: Colors.red.withOpacity(0.3),
      strokeColor: Colors.red,
      strokeWidth: 2,
    ),
  };

  Set<Polyline> Polylines = {
   const Polyline(
      polylineId: PolylineId ('routel'),
      points: [
        LatLng(12.0433, -89.2357),
        LatLng(60.7690, -31.3400),
        LatLng(80.0670, -76.0050),
        LatLng(10.0190, -00.9876),
      ],
      color: Colors.blue,
      width: 10,
      ),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        // polygons
        polygons: polygons,
        // polylines
        polylines: Polylines,
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 15,
        ),
        markers: {
          const Marker(
            markerId: MarkerId(value),
            icon: ,
            position: ,
            )
        },
      ),
    );
  }
}
