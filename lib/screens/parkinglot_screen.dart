// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ParkinglotScreen extends StatefulWidget {
  const ParkinglotScreen({super.key});
  @override
  State<ParkinglotScreen> createState() => _ParkinglotScreenState();
}

class _ParkinglotScreenState extends State<ParkinglotScreen> {
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
  void initState() {
    entrytimeinput.text = "";
    exittimeinput.text = "";

    super.initState();
  }

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
                          Text('Rs. 10 per hour',
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Book Parking Spot',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Colors.blue,
                            child: Icon(
                              Icons.two_wheeler_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                          RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Colors.blue,
                            child: Icon(
                              Icons.directions_car_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                          DropdownButton(
                            // Initial Value
                            value: dropdownvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ]),
                    Container(
                      padding: EdgeInsets.all(15),
                      // height: 150,
                      child: Center(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 200,
                                child: TextField(
                                    controller: entrytimeinput,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.timer),
                                        labelText: "Entry Time"),
                                    readOnly: true,
                                    onTap: () async {
                                      TimeOfDay? entryTime =
                                          await showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );
                                      if (entryTime != null) {
                                        setState(() {
                                          entrytimeinput.text =
                                              entryTime.format(context);
                                          // starttime = TimeOfDay(
                                          //     hour: int.parse(entrytimeinput
                                          //         .text
                                          //         .split(':')[0]),
                                          //     minute: int.parse(entrytimeinput
                                          //         .text
                                          //         .split(':')[1]));
                                          starttime = entryTime;
                                          print("start $starttime");
                                          calcdifference = findTimeDifference(
                                              starttime, endtime);
                                        });
                                      }
                                    }),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                    controller: exittimeinput,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.timer_off),
                                        labelText: "Exit Time"),
                                    readOnly: true,
                                    onTap: () async {
                                      TimeOfDay? exitTime =
                                          await showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );
                                      if (exitTime != null) {
                                        setState(() {
                                          exittimeinput.text =
                                              exitTime.format(context);
                                          // endtime = TimeOfDay(
                                          //     hour: int.parse(exittimeinput.text
                                          //         .split(':')[0]),
                                          //     minute: int.parse(exittimeinput
                                          //         .text
                                          //         .split(':')[1]));
                                          endtime = exitTime;
                                          print("end $endtime");
                                          // print(starttime);
                                          calcdifference = findTimeDifference(
                                              starttime, endtime);
                                        });
                                      }
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Duration $calcdifference',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text('Price Rs. $price',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      )),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
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
                  onPressed: () => {},
                  child: Text('Book Now',
                      style: TextStyle(color: Color(0xffCCE9F2), fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
