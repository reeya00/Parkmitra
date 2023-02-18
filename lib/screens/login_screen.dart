import 'package:flutter/material.dart';
import 'package:parkmitra/screens/home_screen.dart';

import 'nav_bar.dart';

TextStyle myStyle = const TextStyle(fontSize: 15);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String username;
  late String password;

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter some text";
        }
      },
      onChanged: (val) {
        setState(() {
          username = val;
        });
      },
      
      style: myStyle,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: "Username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final passwordField = TextFormField(
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
      obscureText: true,
      style: myStyle,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final loginbutton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: const Color(0xff222651),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            // ignore: avoid_print
            print("Login");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NavBar()));
          },
          padding: const EdgeInsets.all(20),
          child:
              const Text('Login', style: TextStyle(color: Color(0xffCCE9F2))),
        ));
    return Scaffold(
      body: Center(
          child: Container(
              color: const Color(0xff0078B7),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/logo.png', scale: 10),
                    const SizedBox(height: 20),
                    usernameField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    loginbutton,
                  ],
                ),
              ))),
    );
  }
}
