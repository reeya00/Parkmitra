// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parkmitra/screens/constants.dart';
import 'package:parkmitra/screens/signin_screen.dart';
import 'nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'globals.dart';

//use cubit for state management
class Globals {
  static String refresh_token = '';
  static String access_token = '';
  static String user_name = '';
}

TextStyle myStyle = const TextStyle(fontSize: 15);
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
bool loggedin = false;

void loginUser(String username, String password, Function() onSucess) async {
  final response = await http.post(
    // Uri.parse('https://6ff2-110-44-115-169.in.ngrok.io/api/token/'),
    Uri.parse(baseUrl + 'api/token/'),
    
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
    final Map<String, dynamic> responseData = json.decode(response.body);
    // SyncModel model = SyncModel.fromJson(response.body as Map<String, dynamic>>);
    await Hive.openBox('userBox');
    var userBox = Hive.box('userBox');
    userBox.put('accessToken', responseData['access']);
    userBox.put('refreshToken', responseData['refresh']);
    print(userBox.get('accessToken'));
    print(userBox.get('refreshToken'));
    writeUserDataToHive();
    final temp = 'Bearer ' + Globals.access_token;
    Get.snackbar('Sucess', 'Logged In');
    onSucess();
  } else {
    // User is not authenticated
    print('User not authenticated');
    Get.snackbar('Error', 'Log In Failed');
    final Map<String, dynamic> responseData = json.decode(response.body);
    final String errorMessage = responseData['detail'];
    throw Exception(errorMessage);
  }
}

Future<void> writeUserDataToHive() async {
  // await Hive.openBox('userBox');
  final box = Hive.box('userBox');
  final response = await http.get(Uri.parse(baseUrl + 'parkmitra/userdata/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + box.get('accessToken')
      });
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    box.put('id', responseData['id']);
    box.put('username', responseData['username']);
    box.put('firstName', responseData['firstName']);
    box.put('lastName', responseData['lastName']);
    box.put('email', responseData['email']);
    box.put('isActive', responseData['isActive']);
    box.put('vehicle', responseData['vehicle']);
    box.put('session', responseData['session']);
  } else {
    throw Exception('Failed to load data');
  }
}

class LoginScree extends StatefulWidget {
  const LoginScree({super.key});

  @override
  State<LoginScree> createState() => _LoginScreeState();
}

class _LoginScreeState extends State<LoginScree> {
  late String username;
  late String password;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //usernamefield
    final usernameField = TextFormField(
      controller: usernameController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Username is required";
        }
        return null;
      },
      onSaved: (String? val) {
        username = val!;
      },
      style: myStyle,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: "Username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    //passwordfield
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
        color: accentBlue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              loginUser(usernameController.text, passwordController.text, () {
                Get.to(() => NavBar());
                _formkey.currentState!.save();
              });
              // Future.delayed(Duration(seconds: 10));

              // CircularProgressIndicator();
            } else {
              Get.snackbar('Error', 'Wrong Credentials');
            }
          },
          padding: const EdgeInsets.all(20),
          child: const Text('Login', style: TextStyle(color: mutedBlue)),
        ));
    return Scaffold(
      body: Center(
          child: Form(
        key: _formkey,
        child: Container(
            color: mutedBlue,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SvgPicture.asset('assets/images/logo1.svg'),
                  // Image.asset('assets/images/logo.png', scale: 10),
                  const SizedBox(height: 20),
                  usernameField,
                  const SizedBox(height: 20),
                  passwordField,
                  const SizedBox(height: 20),
                  loginbutton,
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () => {Get.to(() => SigninScreen())},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: const TextStyle(
                                fontSize: 15, color: accentBlue),
                          ),
                          const Text(
                            "Sign Up",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: accentBlue,
                                decoration: TextDecoration.underline),
                          )
                        ],
                      ))
                ],
              ),
            )),
      )),
    );
  }
}
