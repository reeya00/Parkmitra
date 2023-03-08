import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

    fetchUserData().then((data) => userData.value = data);
  }
}

Future<Map<String, dynamic>> fetchUserData() async {
  final userBox = Hive.box('userBox');
  final username = userBox.get('username');
  // print('function entered');
  return {'username': username};
}

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final data = controller.userData.value;
          if (data != null) {
            return Text(
              data['username'],
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
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    logout();
                  },
                  textConfirm: 'Logout',
                  cancelTextColor: Colors.blue,
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

  // Navigate to the login screen or home screen
  Get.to(() => LoginScree());
}
