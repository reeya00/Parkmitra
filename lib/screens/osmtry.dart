// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkmitra/screens/app_icons.dart';

class MapOsm extends StatefulWidget {
  const MapOsm({super.key});
  @override
  State<MapOsm> createState() => _MapOsmState();
}

class _MapOsmState extends State<MapOsm> {
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  } 
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
                    icon: Icon(AppIcons.asset_8, size: 35, color: Colors.blueAccent,),
                    color: Colors.red,
                    iconSize: 40,
                    onPressed: () => {
                      getCurrentLocation,
                    },
                  )),
                ),
                Marker(
                  point: LatLng(_currentPosition?.latitude ??0, _currentPosition?.longitude ??0),
                  width: 80,
                  height: 80,
                  builder: (context) => Container(
                      child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 40,
                    onPressed: () => {print('Marker Tapped')},
                  )),
                )
              ],
            ),

            // Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            // Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            // const SizedBox(height: 32),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: getCurrentLocation,
            //     child: const Text("Get Current Location"),
            //   ),
            // )
          ]),
    );
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print("****currentposis**** $_currentPosition");
      });
    }).catchError((e) {
      print(e);
    });
  }
}
