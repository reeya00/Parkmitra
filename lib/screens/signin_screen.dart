<<<<<<< HEAD
=======
import 'dart:math';

>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

<<<<<<< HEAD
Future<http.Response> createUser(String username, String password, String email) async {
  http.Response response = await http.post(
    Uri.parse('http://127.0.0.1:8000/user/register/'),
=======
Future<http.Response> createUser(
    String username, String password, String email) {
  final response = http.post(
    // Uri.parse('http://127.0.0.1:8000/user/register/'), //use this for web
    // Uri.parse('http://10.0.2.2:8000/user/register/'), //use this for emulator and device
    Uri.http("localhost:8000", "/user/register/"),
>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
<<<<<<< HEAD
      'email': email
=======
      'email': email,
>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0
    }),
  );
  return response;
}
<<<<<<< HEAD

void signUp(String username, String password, String email) async {
  final response = await createUser(username, password, email);
  if (response.statusCode == 201) {
    // User created successfully, do something
  } else {
    // Error creating user, handle the error
  }
}
=======
>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0

TextStyle myStyle = const TextStyle(fontSize: 15);
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SigninScreen> {
  late String username;
  late String password;
<<<<<<< HEAD
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
=======
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      controller: _usernameController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Username is required";
        }
        return null;
      },
      controller: usernameController,
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
      controller: _emailController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
        }
        return null;
      },
      controller: emailController,
      onChanged: (val) {
        setState(() {
          username = val;
        });
      },
      style: myStyle,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final passwordField = TextFormField(
      controller: _passwordController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
      controller: passwordController,
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
<<<<<<< HEAD
              signUp(_usernameController.text, _passwordController.text, _emailController.text);
              return;
=======
              createUser(usernameController.text, passwordController.text,
                  emailController.text);
>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0
            }
            // _formkey.currentState!.save();

            // print(username);
            // Navigator.push(context,
<<<<<<< HEAD
            //     MaterialPageRoute(builder: (context) => LoginScreen()));
=======
            // MaterialPageRoute(builder: (context) => LoginScreen()));
>>>>>>> 1b9d9a7cf6c8641b55d004c3eb8377cb25c58be0
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
