// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkmitra/screens/current_location.dart';
import 'package:parkmitra/screens/nav_bar.dart';
import 'package:parkmitra/screens/osmtry.dart';
import 'retriever.dart';

class GlobalsAgain {
  static var temp;
  void retrieve() async {
    GlobalsAgain.temp = await fetchUserData();
  }
}

// import 'package:myapp/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: const TextStyle(fontSize: 25),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          LocationPage(),
          // NavBar()
        ],
      ),
    );
  }
}
