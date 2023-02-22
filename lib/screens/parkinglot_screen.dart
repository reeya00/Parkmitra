// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';

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
  TextEditingController entrytimeinput = TextEditingController();
  TextEditingController exittimeinput = TextEditingController();

  @override
  void initState() {
    entrytimeinput.text = "";
    exittimeinput.text = "";

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("username", style: const TextStyle(fontSize: 25)),
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
                        height: 20,
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
                          SizedBox(width: 15, height: 90),
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
              flex: 5,
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
                          Ink(
                            child: InkWell(
                              child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: _containercolor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.two_wheeler_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          onTap: () {
                                  setState(() {
                                    _containercolor =
                                        _containercolor == Colors.white
                                            ? Colors.blue
                                            : Colors.white;
                                  });
                                },
                          )
                          ),
                          Ink(
                            child: InkWell(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: _containercolor,
                                      width: 5,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.directions_car_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _containercolor =
                                        _containercolor == Colors.white
                                            ? Colors.blue
                                            : Colors.white;
                                  });
                                },),
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
                      height: 150,
                      child: Center(
                        child: Row(
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
                                    TimeOfDay? entryTime = await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );
                                    if (entryTime != null) {
                                      setState(() {
                                        entrytimeinput.text =
                                            entryTime.format(context);
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
                                    TimeOfDay? exitTime = await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );
                                    if (exitTime != null) {
                                      setState(() {
                                        exittimeinput.text =
                                            exitTime.format(context);
                                      });
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
