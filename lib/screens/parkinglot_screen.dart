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

Future<void> writeParkinglotDataToHive() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/parkmitra/parkinglots/'));
  

  if (response.statusCode == 200) {
    final parkinglotBox = await Hive.box('parkingLot');
    final data = json.decode(response.body);
    await parkinglotBox.put('data', data);
  } else {
    throw Exception('Failed to load data');
  }
}

class ParkinglotController extends GetxController {
  Color _containercolor = Colors.blue;
  //for dropdown
  var items = ['Activa Scooter', 'Hyundai Car', 'Yatri BIke'];
  String dropdownvalue = 'Activa Scooter';
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
  void onInit() {
    entrytimeinput.text = "";
    exittimeinput.text = "";
    super.onInit();
    writeParkinglotDataToHive();
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
                      ListTile(
                        title: const Text('Labim Mall',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        subtitle: const Text('Pulchowk, Lalitpur'),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 15, height: 70),
                          Text(
                            '300 km away',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('Rs. 90 per hour',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
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
                          onPressed: () {
                            // Book Parking Lot
                          },
                          child: Text(
                            'Book',
                            style: TextStyle(fontSize: 18),
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
