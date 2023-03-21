import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:parkmitra/screens/parkinglot_screen.dart';
import '../model/model.dart';
import 'qr_scanner.dart';

class ActiveScreenController extends GetxController {
  final sessionData = Rxn<Map<String, dynamic>>();
  Future<Map<String, dynamic>> getSessionFromHive() async {
    print('get session function');
    final sessionBox = await Hive.box<ParkingLot>('parkingLot');
    final accesstoken = sessionBox.get('accessToken');
    final userId = sessionBox.get('user');
    print('user $userId');

    return {'userid': userId};
  }

  @override
  void onInit() {
    super.onInit();
    print('from active screen');
    // getSessionFromHive();
    getSessionFromHive().then((data) => sessionData.value = data);
  }
}

class ActiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activescreenController = Get.put(ActiveScreenController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Obx(() {
          final data = activescreenController.sessionData.value;
          if (data != null) {
            return Text(
              data['userId'],
              style: const TextStyle(fontSize: 25),
            );
          } else if (data == null) {
            // Use the rx getter for hasError
            return const Text("Error loading session data");
          } else {
            return const CircularProgressIndicator();
          }
        }),
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
