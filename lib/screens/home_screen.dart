import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parkmitra/screens/constants.dart';
import 'package:parkmitra/screens/current_location.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:parkmitra/screens/login.dart';
import 'active_screen.dart';

class HomeController extends GetxController {
  final userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    // final userBox = Hive.openBox('userBox');
    fetchUserData().then((data) => userData.value = data);
  }
}

Future<Map<String, dynamic>> fetchUserData() async {
  final userBox = await Hive.box('userBox');
  final id = userBox.get('id');
  final username = userBox.get('username');
  final accessToken = userBox.get('accessToken');
  final vehicle = userBox.get('vehicle');
  final firstName = userBox.get('firstName');
  final lastName = userBox.get('lastName');
  final email = userBox.get('email');
  final refreshToken = userBox.get('refreshToken');
  final session = userBox.get('session');

  // print('function entered');
  return {
    'id': id,
    'username': username,
    'accessToken': accessToken,
    'vehicle': vehicle,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'refreshToken': refreshToken,
    'session': session,
  };
}

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var userBox;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final data = controller.userData.value;
          userBox = Hive.box('userBox');

          if (data != null) {
            return Text(
              userBox.get('username'),
              style: const TextStyle(fontSize: 25),
            );
          } else if (data == null) {
            // Use the rx getter for hasError
            return const Text("Error loading user data");
          } else {
            return const CircularProgressIndicator();
          }
        }),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                Get.defaultDialog(
                  title: 'Confirm Logout',
                  middleText: 'Are you sure you want to logout?',
                  confirmTextColor: mutedBlue,
                  onConfirm: () async {
                    logout();
                  },
                  textConfirm: 'Logout',
                  cancelTextColor: primaryBlue,
                  // onCancel: () => Get.back(),
                  textCancel: 'Cancel',
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Stack(
        children: [
          LocationPage(),
        ],
      ),
    );
  }
}

void logout() async {
  final Box<dynamic> userBox = Hive.box<dynamic>('userBox');
  await userBox.clear();
  print('logged out');
  print(userBox.get('username'));
  // await userBox.();

  // Navigate to the login screen or home screen
  Get.off(() => LoginScree());
}
