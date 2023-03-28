import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:parkmitra/screens/constants.dart';
import 'package:parkmitra/screens/home_screen.dart';
import 'login.dart';
import 'globals.dart';

class SigninController extends GetxController {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void createUser() async {
    final response = await http.post(
      Uri.parse(baseUrl + 'user/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'is_active': 'true',
      }),
    );

    if (response.statusCode == 201) {
      print("sucessfully signed in");
      Get.to(() => LoginScree());
    } else {
      print("error");
      // Get.snackbar(
      //   "Error",
      //   "An error occurred while registering. Please try again later.",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }
}

class SigninScreen extends StatelessWidget {
  final signinController = Get.put(SigninController());

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      controller: signinController.usernameController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Username is required";
        }
        return null;
      },
      onSaved: (String? val) {},
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: "Username",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );

    final emailField = TextFormField(
      controller: signinController.emailController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
        }
        return null;
      },
      onChanged: (val) {},
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );

    final passwordField = TextFormField(
      controller: signinController.passwordController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
      onChanged: (val) {},
      obscureText: true,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );

    final loginbutton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: accentBlue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (signinController.formKey.currentState!.validate()) {
            signinController.createUser();
          }
        },
        padding: const EdgeInsets.all(20),
        child: const Text(
          'Sign Up',
          style: TextStyle(color: mutedBlue),
        ),
      ),
    );

    return Scaffold(
      body: Center(
          child: Form(
        key: signinController.formKey,
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
                  const SizedBox(height: 20),
                  usernameField,
                  const SizedBox(height: 20),
                  emailField,
                  const SizedBox(height: 20),
                  passwordField,
                  const SizedBox(height: 20),
                  loginbutton,
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () => {Get.to(() => LoginScree())},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: const TextStyle(
                                fontSize: 15, color: accentBlue),
                          ),
                          const Text(
                            "Login",
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
