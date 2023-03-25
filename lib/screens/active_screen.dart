import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'constants.dart';
import 'globals.dart';
import 'qr_scanner.dart';
import 'package:http/http.dart' as http;

class ActiveScreenController extends GetxController {
  final RxString spaceCode = RxString('N/A');
  final String parkingTime = '10';
  final String exitTime = '11';

  void fetchSessionData() async {
    final userBox = Hive.box('userBox');
    spaceCode.value = userBox.get('session').last['id'].toString();
    userBox.watch(key: 'session').listen((event) {
      spaceCode.value = event.value.last['id'].toString();
      print('sessionscreen spaceval');
      print(spaceCode.value);
    });
  }

  @override
  void onInit() {
    fetchSessionData();
    super.onInit();
  }
}

class ActiveScreen extends StatelessWidget {
  final ActiveScreenController activeController =
      Get.put(ActiveScreenController());

  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box('userBox');
    var session = <dynamic>[];
    RxList<dynamic> sessionRx;
    // var userBox = Hive.box('userBox');
    // activeController.spaceCode.value = userBox.get('parking_space') ?? 'N/A';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryBlue,
        title: const Text('Active Sessions'),
        actions: <Widget>[
          Container(
            // padding: EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Get.to(() => QRCodeScannerEntry());
              },
              icon: Icon(
                Icons.where_to_vote,
                color: Colors.white,
                size: 35,
              ),
              // child: Text('Verify', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                userBox = Hive.box('userBox');
                session = userBox.get('session');
                sessionRx = session.obs;
                return ListView.builder(
                  itemCount: sessionRx.length,
                  itemBuilder: (context, index) {
                    final session = sessionRx[index];
                    final titleText = session['parking_space'].toString();
                    final subtitleText1 =
                        session['entry_time'].substring(11, 16);
                    final subtitleText2 =
                        session['exit_time'].substring(11, 16);

                    return Card(
                        margin:
                            const EdgeInsets.only(right: 20, left: 20, top: 20),
                        child: Column(children: <Widget>[
                          Row(children: [
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    'Space Code: $titleText',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Entry: ',
                                            ),
                                            TextSpan(
                                                text: subtitleText1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            TextSpan(text: '\t\t\t\tExit: '),
                                            TextSpan(
                                                text: subtitleText2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: primaryBlue,
                                    child: MaterialButton(
                                      onPressed: () {
                                        // Handle "Pay Now" button press
                                        Get.to(() => QRCodeScannerExit());
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        child: Text(
                                          'Pay Now',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )))
                          ])
                        ]));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
