import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'qr_scanner.dart';

class ActiveScreen extends StatelessWidget {
  final String parkingTime = '10';
  final String exitTime = '11';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Vehicle Details'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Text('This is a modal sheet.'),
                      ),
                    );
                  },
                );
              },
              child: Text('Status', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Text('Space ID'),
                        title: Text('Vehicle'),
                        subtitle: Text('entry time: 11, exit time: 12'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Pay Now" button press
                          Get.to(() => QRCodeScanner());
                        },
                        child: Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Text('Space ID'),
                        title: Text('Vehicle'),
                        subtitle: Text('entry time: 11, exit time: 12'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Pay Now" button press
                        },
                        child: Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Text('Space ID'),
                        title: Text('Vehicle'),
                        subtitle: Text('entry time: 11, exit time: 12'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Pay Now" button press
                        },
                        child: Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
