// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'app_icons.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    print(_currentAddress);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    print(_currentPosition);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: FlutterMap(
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
                    builder: (context) => InkWell(
                          child: Icon(
                            AppIcons.asset_8,
                            size: 35,
                            color: Colors.blueAccent,
                            opticalSize: 40,
                          ),
                          onTap: () {
                            setState(() {});
                          },
                        )
                    ),
                Marker(
                    point: LatLng(_currentPosition?.latitude ?? 0,
                        _currentPosition?.longitude ?? 0),
                    width: 80,
                    height: 80,
                    builder: (context) => GestureDetector(
                       child: Icon(
                            Icons.location_on,
                            size: 40,
                            color: Colors.red,
                        ),
                        onTap: () {
                          print("marker tapped");
                          Card(
                          color: Colors.blue,
                          );
                        },
                         
                          
                        )),
              ],
            ),
            PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(
                  points: [
                    LatLng(27.7172, 85.3240),
                    LatLng(_currentPosition?.latitude ?? 0,
                        _currentPosition?.longitude ?? 0)
                  ],
                  color: Colors.blue,
                )
              ],
            )
          ]),
    ));
  }
}
