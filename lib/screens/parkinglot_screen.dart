// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parkmitra/model/model.dart';
import 'package:parkmitra/screens/active_screen.dart';
import 'package:parkmitra/screens/constants.dart';
import 'package:parkmitra/screens/nav_bar.dart';
import 'login.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'globals.dart';
import 'dart:math';

Future<void> writeParkinglotDataToHive(double lat, double lng) async {
  print('writeparkinglotdatatohive entered');
  final parkinglotBox = Hive.box('parkingLot');
  final response =
      await http.get(Uri.parse(baseUrl + 'parkmitra/parkinglots/'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    String parkinglotName = "";
    double parkingRate = 0;
    var parkingSpaces;
    for (final parkinglot in data) {
      if ((parkinglot['lat'] != null && parkinglot['long'] != null) &&
          (parkinglot['lat'] - lat).abs() < 0.0001 &&
          (parkinglot['long'] - lng).abs() < 0.0001) {
        parkinglotName = parkinglot['lot_name'];
        parkingRate = parkinglot['rate_per_hour'];
        parkingSpaces = parkinglot['parking_spaces'];
        break;
      }
    }
    if (parkinglotName != null) {
      print('parking if entered');
      print(parkingRate);
      parkinglotBox.putAll({
        'lotName': parkinglotName,
        'lat': lat,
        'lng': lng,
        'rate': parkingRate,
        'parkingSpaces': parkingSpaces
      });
    }

    print(parkinglotBox.get('lotName'));
  } else {
    throw Exception('Failed to load data');
  }
}

class ParkinglotController extends GetxController {
  final parkinglotData = Rxn<Map<String, dynamic>>();
  final userData = Rxn<Map<String, dynamic>>();
  final profileData = Rxn<Map<String, dynamic>>();
  RxList<String> vehiclelist = <String>[].obs;
  List<int> vehicleIndexList = [];
  int selectedVehicleId = 0;
  Rx<String> selectedDropdown = Rx<String>('');
  Color _containercolor = Colors.blue;
  TimeOfDay starttime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endtime = TimeOfDay(hour: 0, minute: 0);
  String calcdifference = "";
  double price = 0;
  TextEditingController entrytimeinput = TextEditingController();
  TextEditingController exittimeinput = TextEditingController();

  @override
  void onInit() async {
    entrytimeinput.text = "";
    exittimeinput.text = "";
    super.onInit();
    await Hive.openBox('userBox');
    getVehicleData();
  }

  String findTimeDifference(entrytime, exittime) {
    print("from findtime $entrytime $exittime");
    final int hourDifference = entrytime.hour - exittime.hour;
    final int minuteDifference = entrytime.minute - exittime.minute;
    final Duration duration =
        Duration(hours: hourDifference, minutes: minuteDifference);
    final differenceTime = durationToString(duration.abs());
    print('Time Difference: $differenceTime');
    price = findPrice(duration.abs());
    return differenceTime;
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    return "$twoDigitHours:$twoDigitMinutes";
  }

  double findPrice(Duration duration) {
    final double rate = 1.5;
    final double price = duration.inMinutes * rate;
    return price;
  }

  void getVehicleData() {
    print("enter getvehicledata");
    final userBox = Hive.box('userBox');
    var items = userBox.get('vehicle');
    for (final item in items) {
      print(item);
      var vehicle = item['brand_name'] + ' ' + item['vehicle_model'];
      vehiclelist.add(vehicle);
      vehicleIndexList.add(item['id']);
      print(vehicle);
    }
    selectedDropdown.value = vehiclelist[0];
    print(vehiclelist);
    print(selectedDropdown);
    print("exit getvehicledata");
  }
}

class ParkinglotScreen extends StatelessWidget {
  final parkinglotController = Get.put(ParkinglotController());
  var box = Hive.box('parkingLot');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book", style: const TextStyle(fontSize: 25)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: Card(
                  color: mutedBlue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(box.get('lotName'),
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 15, height: 100),
                          Text(
                            '300 m away',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          // Text(parkinglotController.parkinglotData.value?['rate'],
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Book a Spot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Select a Vehicle',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black.withOpacity(0.8)),
                      ),
                      Obx(() => DropdownButton<String>(
                            value: parkinglotController.selectedDropdown.value,
                            items: parkinglotController.vehiclelist
                                .map((String items) => DropdownMenuItem<String>(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? newvalue) {
                              parkinglotController.selectedDropdown.value =
                                  newvalue!;
                              var vehicle;
                              var count = 0;
                              for (vehicle
                                  in parkinglotController.vehiclelist) {
                                if (vehicle == newvalue) {
                                  parkinglotController.selectedVehicleId =
                                      parkinglotController
                                          .vehicleIndexList[count];
                                  break;
                                }
                                count++;
                              }
                            },
                          )),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Entry Time',
                            style: TextStyle(fontSize: 12),
                          ),
                          // SizedBox(
                          //   width: 100,
                          // ),
                          Text(
                            'Exit Time',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: parkinglotController.entrytimeinput,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                parkinglotController.starttime = picked;
                                parkinglotController.entrytimeinput.text =
                                    DateFormat('HH:mm').format(DateTime(2023,
                                        03, 05, picked.hour, picked.minute));
                                parkinglotController.update();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Entry Time',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.timer),
                            ),
                          )),
                          // SizedBox(height: 20),

                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: parkinglotController.exittimeinput,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                parkinglotController.endtime = picked;
                                parkinglotController.exittimeinput.text =
                                    DateFormat('HH:mm').format(DateTime(2023,
                                        03, 05, picked.hour, picked.minute));
                                parkinglotController.calcdifference =
                                    parkinglotController.findTimeDifference(
                                        parkinglotController.starttime,
                                        parkinglotController.endtime);
                                parkinglotController.update();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Exit Time',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.timer),
                            ),
                          )),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Time Difference: ${parkinglotController.calcdifference}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Price: Rs. ${parkinglotController.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 1),
                      Expanded(
                          child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: primaryBlue,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () async {
                            // Book Parking Lot
                            print('onpressed clicked book');
                            DateTime now = DateTime.now();
                            DateTime dateTime_start = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                parkinglotController.starttime.hour,
                                parkinglotController.starttime.minute);
                            String iso8601string_start =
                                dateTime_start.toIso8601String();
                            DateTime dateTime_end = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                parkinglotController.endtime.hour,
                                parkinglotController.endtime.minute);
                            String iso8601string_end =
                                dateTime_end.toIso8601String();
                            print(iso8601string_start + '000Z');
                            print(iso8601string_end + '000Z');
                            final userBox = await Hive.openBox('userBox');
                            // final parkingLotBox =
                            //     await Hive.openBox('parkingLot');
                            // print(parkingLotBox.get('parkingSessions'));
                            final accesstoken = userBox.get('accessToken');
                            final userID = userBox.get('id');
                            int parkingSpace = spaceList[index];
                            index++;
                            print(index);
                            final postResponse = await http.post(
                                Uri.parse(baseUrl + 'parkmitra/sessions/add'),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Authorization': 'Bearer $accesstoken'
                                },
                                body: jsonEncode(<String, String>{
                                  "user": "$userID",
                                  "vehicle": parkinglotController
                                      .selectedVehicleId
                                      .toString(),
                                  "parking_space": parkingSpace.toString(),
                                  "entry_time": iso8601string_start + '000Z',
                                  "exit_time": iso8601string_end + '000Z'
                                }));
                            if (postResponse.statusCode == 201) {
                              writeUserDataToHive();
                              print(postResponse.body);
                              print("Parking Spot booked successfully");
                              Get.snackbar('Success', 'Booking Successful');
                            }
                            Get.offAll(() => NavBar());
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Text(
                              'Book',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
