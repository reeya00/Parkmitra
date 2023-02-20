// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ParkinglotScreen extends StatefulWidget {
  const ParkinglotScreen({super.key});
  @override
  State<ParkinglotScreen> createState() => _ParkinglotScreenState();
}

class _ParkinglotScreenState extends State<ParkinglotScreen> {
  var items = ['Activa Scooter', 'Hyundai Car', 'Yatri BIke'];
  String dropdownvalue = 'Activa Scooter';

  @override
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
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.two_wheeler_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.directions_car_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          DropdownButton(
                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
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
