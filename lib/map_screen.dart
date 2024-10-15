import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatelessWidget {
  Map data;

  MapScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
              double.parse(data['latitude']), double.parse(data['longitude'])),
          initialZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          CircleLayer(circles: [
            CircleMarker(
                point: LatLng(double.parse(data['latitude']),
                    double.parse(data['longitude'])),
                radius: 5,
                color: Colors.red),
          ]),
        ],
      ),
    );
  }
}
