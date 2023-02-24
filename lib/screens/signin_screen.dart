import 'dart:math';
import 'package:flutter/material.dart';
import 'login.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> createUser(
    String username, String password, String email) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/user/register/'), //use this for web
    // Uri.parse('http://10.0.2.2:8000/user/register/'), //use this for emulator and device
    // Uri.http("localhost:8000", "/user/register/"),
    // Uri.parse('http://192.168.0.1:8000/user/register/'),

    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'email': email,
      'is_active': 'true'
    }),
  );
  return response;
}

TextStyle myStyle = const TextStyle(fontSize: 15);
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SigninScreen> {
  late String username;
  late String email;
  late String password;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

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
      onSaved: (String? val) {
        username = val!;
      },
      style: myStyle,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: "Username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final emailField = TextFormField(
      controller: emailController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
      style: myStyle,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: "Email",
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
            if (_formkey.currentState!.validate()) {
              createUser(usernameController.text, passwordController.text,
                  emailController.text);
              _formkey.currentState!.save();

              // print(username);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScree()));
            }
          },
          padding: const EdgeInsets.all(20),
          child:
              const Text('Sign Up', style: TextStyle(color: Color(0xffCCE9F2))),
        ));
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
                  emailField,
                  const SizedBox(height: 20),
                  passwordField,
                  const SizedBox(height: 20),
                  loginbutton,
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScree()))
                          },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: const TextStyle(
                                fontSize: 15, color: const Color(0xff222651)),
                          ),
                          const Text(
                            "Login",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff222651),
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

// create a Map object with user data
Map<String, dynamic> userData = {
  'username': 'john_doe',
  'email': 'john.doe@example.com',
  'password': 'password123'
};

String jsonUserData = jsonEncode(userData);
