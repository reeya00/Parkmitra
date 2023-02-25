import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkmitra/screens/current_location.dart';
import 'package:parkmitra/screens/nav_bar.dart';
import 'package:parkmitra/screens/osmtry.dart';
import 'retriever.dart';
import 'active_screen.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> userData;
  bool reload = false;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data!['username'],
                style: const TextStyle(fontSize: 25),
              );
            } else if (snapshot.hasError) {
              // Reload the HomeScreen if an error occurs
              Future.delayed(Duration(milliseconds: 500)).then((_) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => NavBar()));
              });
              return const Text("Error loading user data");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          LocationPage(),
        ],
      ),
    );
  }
}
