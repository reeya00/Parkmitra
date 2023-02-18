import 'package:flutter/material.dart';

import 'login_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
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
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
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
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final passwordField = TextFormField(
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
              return;
            }
            _formkey.currentState!.save();
            // print(username);
            Navigator.push(context,
               MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          padding: const EdgeInsets.all(20),
          child:
              const Text('Sign in', style: TextStyle(color: Color(0xffCCE9F2))),
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
