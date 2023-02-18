// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


class MapOsm extends StatefulWidget {
  // const MapOsm({super.key});
  @override
  State<MapOsm> createState() => _MapOsmState();
}

class _MapOsmState extends State<MapOsm> {
  Position? _currentPosition;
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      body: FlutterMap(
          options: MapOptions(center: LatLng(27.7172, 85.3240), minZoom: 10.0),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            // ignore: prefer_const_constructors
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(27.7172, 85.3240),
                  width: 80,
                  height: 80,
                  builder: (context) => Container(
                    child: IconButton(
                      icon : Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 40,
                      onPressed: () => {
                        print('Marker Tapped')
                      },
                    )
                  ),
                ),
            ],),
        
          // Text('LAT: ${_currentPosition?.latitude ?? ""}'),
          // Text('LNG: ${_currentPosition?.longitude ?? ""}'),
          // const SizedBox(height: 32),
          // ElevatedButton(
          //   onPressed: getCurrentLocation,
          //   child: const Text("Get Current Location"),)
          
          ]),
    );
  }

  getCurrentLocation() {
    Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e) {
        print(e);
      });
  }
}

