// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:parkmitra/screens/home_screen.dart';
import 'package:parkmitra/screens/signin_screen.dart';
import 'nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextStyle myStyle = const TextStyle(fontSize: 15);
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
bool loggedin = false;

Future<Map<String, dynamic>> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/token/'), //use this for web
    // Uri.parse('http://10.0.2.2:8000/user/register/'), //use this for emulator and device
    // Uri.http("localhost:8000", "/user/register/"),
    // Uri.parse('http://192.168.0.1:8000/user/register/'),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    // User is authenticated
    print('User authenticated');
    loggedin = true;
    final Map<String, dynamic> responseData = json.decode(response.body);
    final token = responseData['token'];
    final username = responseData['username'];
    return {'token': token, 'username': username};
  } else {
    // User is not authenticated
    print('User not authenticated');
    final Map<String, dynamic> responseData = json.decode(response.body);
    final String errorMessage = responseData['detail'];
    throw Exception(errorMessage);
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String username;
  late String password;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      controller: usernameController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Username is required";
        }
        return null;
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
      controller: passwordController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
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
              // if (_formkey.currentState!.validate()) {
            //   loginUser(usernameController.text, passwordController.text,);
            //   _formkey.currentState!.save();
            //   Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => NavBar()));

            // }

            loginUser(usernameController.text,passwordController.text,);
            // ignore: avoid_print
            print(loggedin);
            if(loggedin = true){
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavBar()));
            }
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
                    const SizedBox(height: 20,),
                    TextButton(
                      onPressed: ()=>{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SigninScreen()))
                      }, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                        const Text(
                        "Don't have an account? ",
                        style: const TextStyle(fontSize: 15, color:const Color(0xff222651) ),
                        ),
                        const Text("Sign Up",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color:const Color(0xff222651),
                        decoration: TextDecoration.underline
                        ),
                        )
                        ],
                      )
                    )
                  ],
                ),
              ))),
    );
  }
}
