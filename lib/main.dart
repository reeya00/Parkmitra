import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:parkmitra/screens/constants.dart';
import 'package:parkmitra/screens/login.dart';
import 'package:parkmitra/screens/nav_bar.dart';
import 'package:parkmitra/screens/qr_scanner.dart';
import 'package:parkmitra/screens/signin_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'model/model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('user');
  Hive.registerAdapter(ParkingLotAdapter());
  await Hive.openBox<ParkingLot>('parkingLot');

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedSplashScreen(
    splash: Image.asset('assets/images/logo2.png'),
    splashIconSize: 100,
    nextScreen: LoginScree(),
    splashTransition: SplashTransition.fadeTransition,
    pageTransitionType: PageTransitionType.bottomToTop,
    backgroundColor: mutedBlue,
    duration: 3000,
  ),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
//   }
// }
