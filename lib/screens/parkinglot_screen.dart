// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';

// Future<void> writeParkinglotDataToHive(double lat, double lng) async {
//   final response =
//       await http.get(Uri.parse('http://127.0.0.1:8000/parkmitra/parkinglots/'));
//   if (response.statusCode == 200) {
//     final parkinglotBox = await Hive.box('parkingLot');
//     final data = json.decode(response.body);
//     await parkinglotBox.put('data', data);
//     parkinglotBox.close();
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

Future<void> writeParkinglotDataToHive(double lat, double lng) async {
  print('writeparkinglotdatatohive entered');
  final parkinglotBox = await Hive.openBox('parkingLot');
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/parkmitra/parkinglots/'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    String parkinglotName = "";
    double parkingRate = 0;
    for (final parkinglot in data) {
      if ((parkinglot['lat'] != null && parkinglot['long'] != null) &&
          (parkinglot['lat'] - lat).abs() < 0.0001 &&
          (parkinglot['long'] - lng).abs() < 0.0001) {
        parkinglotName = parkinglot['lot_name'];
        parkingRate = parkinglot['rate_per_hour'];
        break;
      }
    }

    if (parkinglotName != null) {
      print('parking if entered');
      print(parkingRate);
      await parkinglotBox.putAll({
        'lotName': parkinglotName,
        'lat': lat,
        'lng': lng,
        'rate': parkingRate
      });
    }

    await parkinglotBox.close();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Map<String, dynamic>> fetchParkinglotData() async {
  final parkinglotBox = await Hive.openBox('parkinglot');
  final lotName = parkinglotBox.get('lotName');
  final rate = parkinglotBox.get('rate');
  // print('function entered: $lotName');
  return {'lotName': lotName};
}

class ParkinglotController extends GetxController {
  final parkinglotData = Rxn<Map<String, dynamic>>();
  final userData = Rxn<Map<String, dynamic>>();
  final profileData = Rxn<Map<String, dynamic>>();

  var items = ['Activa Scooter', 'Hyundai Car', 'Yatri Bike'];
  String dropdownvalue = 'Activa Scooter';

  // final parkinglotBox =  Hive.box('parkingLot');

  Color _containercolor = Colors.blue;
  //for dropdown

  TimeOfDay starttime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endtime = TimeOfDay(hour: 0, minute: 0);
  String calcdifference = "";
  double price = 0;

  TextEditingController entrytimeinput = TextEditingController();
  TextEditingController exittimeinput = TextEditingController();

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

  @override
  void onInit() async {
    entrytimeinput.text = "";
    exittimeinput.text = "";
    super.onInit();
    // writeParkinglotDataToHive();
    fetchParkinglotData().then((data) => parkinglotData.value = data);
    fetchUserData().then((userData) => profileData.value = userData);
    final userBox = await Hive.openBox('userBox');
    var items = userBox.get('vehicle');
    for (final data in items) {
      print(data['brand_name']);
    }
    String dropdownvalue = 'Activa Scooter';
  }
}

class ParkinglotScreen extends StatelessWidget {
  final parkinglotController = Get.put(ParkinglotController());

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
              flex: 3,
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Colors.blue.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(title: Obx(() {
                        final data = parkinglotController.parkinglotData.value;
                        if (data != null) {
                          // print(data['lotName']);
                          return Text(
                            data['lotName'],
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold),
                          );
                        } else if (data == null) {
                          // Use the rx getter for hasError
                          return const Text("Error loading parkinglot data");
                        } else {
                          return const CircularProgressIndicator();
                        }
                        //   Text(data['lotName'],
                        //     style: TextStyle(
                        //         fontSize: 40, fontWeight: FontWeight.bold)),
                        // subtitle: const Text('Pulchowk, Lalitpur'),
                      })),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 15, height: 140),
                          Text(
                            '300 km away',
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
                color: Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Book a Spot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Select a Vehicle',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black.withOpacity(0.8)),
                      ),
                      DropdownButton(
                        value: parkinglotController.dropdownvalue,
                        items: parkinglotController.items
                            .map((String items) => DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newvalue) {
                          parkinglotController.dropdownvalue = newvalue!;
                          parkinglotController.update();
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Entry Time',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(
                            width: 182,
                          ),
                          Text(
                            'Exit Time',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                              hintText: 'Enter Entry Time',
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
                              hintText: 'Enter Exit Time',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.timer),
                            ),
                          )),
                        ],
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 90),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        width: 400,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () async {
                              // Book Parking Lot
                              print('onpressed clicked book');
                              final temp = 'Bearer ' + Globals.access_token;
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
                              final accesstoken = userBox.get('accessToken');
                              final postResponse = await http.post(
                                  Uri.parse(
                                      'http://127.0.0.1:8000/parkmitra/sessions/add'),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization': 'Bearer ' + accesstoken
                                  },
                                  body: jsonEncode(<String, String>{
                                    "user": "1",
                                    "vehicle": "1",
                                    "parking_spot": "1",
                                    "entry_time": iso8601string_start + '000Z',
                                    "exit_time": iso8601string_end + '000Z'
                                  }));
                              if (postResponse.statusCode == 201) {
                                print("Parking Spot booked successfully");
                                Get.snackbar('Success', 'Booking Successful');
                              }
                            },
                            child: Text(
                              'Book',
                              style: TextStyle(fontSize: 18),
                            )),
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
