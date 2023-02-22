import 'package:flutter/material.dart';
import 'package:parkmitra/screens/current_location.dart';
import 'package:parkmitra/screens/home_screen.dart';
import 'package:parkmitra/screens/login_screen.dart';
import 'package:parkmitra/screens/nav_bar.dart';
import 'package:parkmitra/screens/osmtry.dart';
import 'package:parkmitra/screens/parkinglot_screen.dart';
import 'package:parkmitra/screens/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen("username"),
    );
  }
}
