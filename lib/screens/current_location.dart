// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkmitra/screens/constants.dart';
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

  void showBottomSheet(String locationName, String location, String price) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 1),
            )
          ],
        ),
        height: 280,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ListTile(
              title: Text(
                locationName,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                location,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: 1,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '300 m',
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rs. $price per hour',
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: primaryBlue,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () => Get.to(ParkinglotScreen()),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    'Visit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    points: points, color: Colors.blue.shade900, strokeWidth: 4)
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
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.6771,
                              85.3171,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Labim Mall', 'Patan', '10');
                      }),
                ),
                Marker(
                  point: LatLng(27.689787, 85.319058),
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
                        writeParkinglotDataToHive(27.689787, 85.319058);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.689787,
                              85.319058,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Norvic Hospital', 'Thapathali, Kathmandu', '10');
                      }),
                ),
                Marker(
                  point: LatLng(27.673732729937345, 85.31086292236026),
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
                        writeParkinglotDataToHive(
                            27.673732729937345, 85.31086292236026);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.673732729937345,
                              85.31086292236026,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Central Zoo', 'Jawalakhel, Lalitpur', '10');
                      }),
                ),
                //DobhiGHat
                Marker(
                  point: LatLng(27.67478808012014, 85.30104276430856),
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
                        writeParkinglotDataToHive(
                            27.67478808012014, 85.30104276430856);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.67478808012014,
                              85.30104276430856,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Nepal College of Management',
                            'Dhobighat, Lalitpur', '10');
                      }),
                ),
                //EkantaKuna
                Marker(
                  point: LatLng(27.666197956762637, 85.30989522187775),
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
                        writeParkinglotDataToHive(
                            27.666197956762637, 85.30989522187775);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.666197956762637,
                              85.30989522187775,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Newa Food Land', 'Ekantakuna, Lalitpur', '10');
                      }),
                ),
                //Nara Park
                Marker(
                  point: LatLng(27.667417984012754, 85.31636097146453),
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
                        writeParkinglotDataToHive(
                            27.667417984012754, 85.31636097146453);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.667417984012754,
                              85.31636097146453,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Nara Park', 'Kusunti, Lalitpur', '10');
                      }),
                ),
                //Patan Hospital
                Marker(
                  point: LatLng(27.66836304410175, 85.32065925526598),
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
                        writeParkinglotDataToHive(
                            27.66836304410175, 85.32065925526598);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.66836304410175,
                              85.32065925526598,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Patan Hospital', 'Itapukhu, Lalitpur ', '10');
                      }),
                ),

                //Nirvana College
                Marker(
                  point: LatLng(27.66707485918133, 85.32468449278204),
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
                        writeParkinglotDataToHive(
                            27.66707485918133, 85.32468449278204);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.66707485918133,
                              85.32468449278204,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Nirvana College', ' Itapukhu, Lalitpur ', '10');
                      }),
                ),

                //Premier International School
                Marker(
                  point: LatLng(27.65316606762367, 85.3287041375297),
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
                        writeParkinglotDataToHive(
                            27.65316606762367, 85.3287041375297);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.65316606762367,
                              85.3287041375297,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Premier International School',
                            'Khumaltar, Lalitpur', '10');
                      }),
                ),
                //Mahalaxmistan
                Marker(
                  point: LatLng(27.662802422551138, 85.31893113931176),
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
                        writeParkinglotDataToHive(
                            27.662802422551138, 85.31893113931176);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.662802422551138,
                              85.31893113931176,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Mahalaxmistan Temple', 'Kusunti, Lalitpur', '10');
                      }),
                ),
                //Gwarko Mall
                Marker(
                  point: LatLng(27.666890352070283, 85.33311629990231),
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
                        writeParkinglotDataToHive(
                            27.666890352070283, 85.33311629990231);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.666890352070283,
                              85.33311629990231,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Gwarko Mall',
                            'Gwarko-Lamatar Road, Lalitpur', '10');
                      }),
                ),
                //Big Mark
                Marker(
                  point: LatLng(27.672722527080502, 85.33349116061454),
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
                        writeParkinglotDataToHive(
                            27.672722527080502, 85.33349116061454);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.672722527080502,
                              85.33349116061454,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Big Mart', 'Bhola Dhoka, Lalitpur', '10');
                      }),
                ),

                //UNESCO
                Marker(
                  point: LatLng(27.685214747425988, 85.30590228832882),
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
                        writeParkinglotDataToHive(
                            27.685214747425988, 85.30590228832882);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.685214747425988,
                              85.30590228832882,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('UNESCO', 'Sanepa, Lalitpur', '10');
                      }),
                ),

                //BHatBHateni
                Marker(
                  point: LatLng(27.675011135835042, 85.34491431146905),
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
                        writeParkinglotDataToHive(
                            27.675011135835042, 85.34491431146905);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.675011135835042,
                              85.34491431146905,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'BhatBhateni', 'KotDevi, Kathmandu', '10');
                      }),
                ),

                //Kantipur Hospital
                Marker(
                  point: LatLng(27.685806059751187, 85.3449327517264),
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
                        writeParkinglotDataToHive(
                            27.685806059751187, 85.3449327517264);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.685806059751187,
                              85.3449327517264,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Kantipur Hospital',
                            'Subidhanagar, Kathmandu ', '20');
                      }),
                ),

                //Big Maurder
                Marker(
                  point: LatLng(27.678137968884517, 85.33924521695906),
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
                        writeParkinglotDataToHive(
                            27.678137968884517, 85.33924521695906);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.678137968884517,
                              85.33924521695906,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Big Mart', 'Subidhanagar, Kathmandu', '10');
                      }),
                ),

                //trolly Bus Station
                Marker(
                  point: LatLng(27.68792245767365, 85.33890943029934),
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
                        writeParkinglotDataToHive(
                            27.68792245767365, 85.33890943029934);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.68792245767365,
                              85.33890943029934,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Trolly Bus Station',
                            'Naya Baneshwar, Kathmandu ', '25');
                      }),
                ),

                //Oliz Store
                Marker(
                  point: LatLng(27.69003295148972, 85.32635710133425),
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
                        writeParkinglotDataToHive(
                            27.69003295148972, 85.32635710133425);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.69003295148972,
                              85.32635710133425,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Oliz Store', 'Buddha Nagar, Kathmandu ', '15');
                      }),
                ),

                //BhatBhateni
                Marker(
                  point: LatLng(27.6930809381547, 85.32830787532528),
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
                        writeParkinglotDataToHive(
                            27.6930809381547, 85.32830787532528);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.6771,
                              85.3171,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'BhatBhateni', ' Buddha Nagar, Kathmandu', '10');
                      }),
                ),

                //United World Trade Centre
                Marker(
                  point: LatLng(27.6941223099765, 85.31361261376355),
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
                        writeParkinglotDataToHive(
                            27.6941223099765, 85.31361261376355);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.6941223099765,
                              85.31361261376355,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'UWTO', 'Tripureshwar, Kathmandu ', '10');
                      }),
                ),

                //Cvil Mall
                Marker(
                  point: LatLng(27.69940040683577, 85.31264218788753),
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
                        writeParkinglotDataToHive(
                            27.69940040683577, 85.31264218788753);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.69940040683577,
                              85.31264218788753,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Civil Mall', 'Tripureshwar, Kathmandu', '20');
                      }),
                ),

                //Kathmandu Fun Pork
                Marker(
                  point: LatLng(27.700979320099403, 85.31960066109141),
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
                        writeParkinglotDataToHive(
                            27.700979320099403, 85.31960066109141);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.700979320099403,
                              85.31960066109141,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet(
                            'Kathmandu Fun Park', 'Baghbazar, Kathmandu', '15');
                      }),
                ),

                //Agro to the culture
                Marker(
                  point: LatLng(27.696500168013205, 85.32080450246708),
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
                        writeParkinglotDataToHive(
                            27.696500168013205, 85.32080450246708);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.696500168013205,
                              85.32080450246708,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);
                        }
                        showBottomSheet('Agricultural development bank Ltd',
                            'Thapathali, Kathmandu', '10');
                      }),
                ),

                //Kathway HOstel
                Marker(
                  point: LatLng(27.700365670586148, 85.35140989236685),
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
                        writeParkinglotDataToHive(
                            27.700365670586148, 85.35140989236685);
                        if (_currentPosition != null) {
                          getDirections(
                              _currentPosition?.latitude ?? 0,
                              _currentPosition?.longitude ?? 0,
                              27.700365670586148,
                              85.35140989236685,
                              points);
                          //getDirections(27.6994,85.3129, 27.6771, 85.3171,points);Gairi Gaun, Kathmandu'
                        }
                        showBottomSheet('Kathway Hostel & Homestay',
                            'Gairi Gaun, Kathmandu', '30');
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
