import 'package:flutter/material.dart';
import 'package:parkmitra/screens/home_screen.dart';
import 'package:parkmitra/screens/signin_screen.dart';
import 'nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextStyle myStyle = const TextStyle(fontSize: 15);
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
    // print('User authenticated');
    final Map<String, dynamic> responseData = json.decode(response.body);
    final refresh_token = responseData['refresh'];
    final access_token = responseData['access'];
    final username = responseData['username'];
    
    // storeTokens(refresh_token, access_token);
    // return {
    //   'refresh_token': responseData['refresh'],
    //   'access_token': responseData['access'],
    //   'username': username
    // };
  } else {
    // User is not authenticated
    // print('User not authenticated');
    final Map<String, dynamic> responseData = json.decode(response.body);
    final String errorMessage = responseData['detail'];
  }
  throw Exception("errorMessage");

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
        color: const Color(0xff222651),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              loginUser(
              usernameController.text,
              passwordController.text,
            );
              _formkey.currentState!.save();

              // print(username);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          },
          padding: const EdgeInsets.all(20),
          child:
              const Text('Login', style: TextStyle(color: Color(0xffCCE9F2))),
        )
      );
    return Scaffold(
      body: Center(
          child: Form(
        key: _formkey,
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
            )),
      )),
    );
  }
}