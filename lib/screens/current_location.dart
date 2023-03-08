// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkmitra/screens/parkinglot_screen.dart';
import 'dart:math';
import 'app_icons.dart';
import 'direction.dart';

class MarkerGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  MarkerGestureDetector({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: child,
    );
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  Position? _currentPosition;
  List<LatLng> points = [];

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
    // print(_currentAddress);
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
          options: MapOptions(center: LatLng(27.6771, 85.3171), minZoom: 10.0),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(
                  points: points,
                  color: Colors.blue.shade900,
                  strokeWidth: 4
                )
              ],
            ),
            // ignore: prefer_const_constructors
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(27.6771, 85.3171),
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
                        print("markertapped");
                        writeParkinglotDataToHive(27.6771, 85.3171);
                        if (_currentPosition != null){
                          getDirections(_currentPosition?.latitude ??0,_currentPosition?.longitude??0, 27.6771, 85.3171,points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Card(
                                  color: Colors.blue.shade100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ListTile(
                                        title: const Text('Labim Mall',
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold)),
                                        subtitle:
                                            const Text('Pulchowk, Lalitpur'),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(width: 15, height: 20),
                                          Text(
                                            '300 km away',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('Rs. 10 per hour',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ParkinglotScreen())),
                                            child: Text(
                                              "Visit",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }),
                ),
                Marker(
                  point: LatLng(_currentPosition?.latitude ?? 0,
                      _currentPosition?.longitude ?? 0),
                  width: 80,
                  height: 80,
                  builder: (context) => MarkerGestureDetector(
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                    onTap: () {
                      print("marker tapped");
                      // Do something when the marker is tapped
                    },
                  ),
                ),
              ],
            ),
          ]),
    ));
  }
}
