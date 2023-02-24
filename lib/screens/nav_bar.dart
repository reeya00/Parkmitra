// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:parkmitra/screens/active_screen.dart';
import 'package:parkmitra/screens/current_location.dart';
import 'package:parkmitra/screens/home_screen.dart';
import 'package:parkmitra/screens/profile_screen.dart';
// import 'package:myapp/screens/login_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List pages = [
    // LocationPage(),
    HomeScreen(),
    ActiveScreen(),
    ProfileScreen(),
  ];

  @override
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        // padding:EdgeInsets.only(bottom: 20) ,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          // boxShadow: [
          //   BoxShadow(color: Color.fromARGB(95, 46, 46, 46), spreadRadius: 0, blurRadius: 10),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
              onTap: onTap,
              currentIndex: currentIndex,
              backgroundColor: Colors.blueAccent,
              iconSize: 25,
              // selectedFontSize: 20,
              selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
              selectedItemColor: Colors.white,
              selectedLabelStyle: TextStyle(color: Colors.white),
              unselectedIconTheme: IconThemeData(color: Color(0xff222651)),
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Color(0xff222651)),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.query_builder_rounded,
                  ),
                  label: 'Active',
                  backgroundColor: Color(0xff222651),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                  ),
                  label: 'Profile',
                  backgroundColor: Color(0xff222651),
                ),
              ]),
        ),
      ),
    );
  }
}
