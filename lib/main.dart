import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:parkmitra/screens/login.dart';
import 'package:parkmitra/screens/login_screen.dart';
import 'package:parkmitra/screens/nav_bar.dart';
import 'package:parkmitra/screens/signin_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('user');
  Hive.registerAdapter(ParkingLotAdapter());
  await Hive.openBox<ParkingLot>('parkingLot');

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: LoginScree() as Widget,
        ),
      ),
    );
  }
}
