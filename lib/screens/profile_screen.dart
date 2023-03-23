import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'globals.dart';

class Vehicle {
  final String name;
  final String numberPlate;
  final String vehicleModel;
  final String vehicleColor;
  final String vehicleType;

  Vehicle({
    required this.name,
    required this.numberPlate,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehicleType,
  });
}

class ProfileScreenController extends GetxController {
  final profileData = Rxn<Map<String, dynamic>>();
  @override
  void onInit() {
    fetchUserData().then((data) => profileData.value = data);
    // super.onInit();
  }
}

class ProfileScreen extends StatelessWidget {
  final profilescreenController = Get.put(ProfileScreenController());
  final _vehicles = <Vehicle>[].obs;

  String type = 'BIKE';

  Future<void> addNewVehicle(
    String name,
    String numberPlate,
    String vehicleModel,
    String vehicleColor,
    String type,
  ) async {
    try {
      print('box in making');
      var userBox = await Hive.openBox('userBox');
      final accesstoken = userBox.get('accessToken');
      print(userBox);
      final String id = userBox.get('id').toString();
      // final ownerID = userBox.get('id');
      final response = await http.post(
        Uri.parse(baseUrl + 'parkmitra/addvehicle/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + accesstoken
        },
        body: jsonEncode(<String, String>{
          "vehicle_type": type,
          "brand_name": name,
          "vehicle_model": vehicleModel,
          "color": vehicleColor,
          "plate_number": numberPlate,
          "owner": id
        }),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final userBox = await Hive.openBox('userBox');
        final vehicleList = userBox.get('vehicle') as List<dynamic>;
        vehicleList.add(responseData);
        userBox.put('vehicle', vehicleList);
      } else {
        print(response.statusCode);
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String errorMessage = responseData['detail'];
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred while adding the vehicle.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void addVehicle(
    String name,
    String numberPlate,
    String vehicleModel,
    String vehicleColor,
    String vehicleType,
  ) {
    final newVehicle = Vehicle(
      name: name,
      numberPlate: numberPlate,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      vehicleType: vehicleType,
    );
    _vehicles.add(newVehicle);
  }

  void _addVehicle() async {
    String name = '';
    String numberPlate = '';
    String vehicleColor = '';
    String vehicleModel = '';

    await Get.defaultDialog(
      title: 'Add Vehicle',
      content: SizedBox(
        height: 300,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Vehicle Name',
              ),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Number Plate',
              ),
              onChanged: (value) {
                numberPlate = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Color',
              ),
              onChanged: (value) {
                vehicleColor = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Vehicle Model',
              ),
              onChanged: (value) {
                vehicleModel = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    type = 'BIKE';
                    print(type);
                  },
                  child: Icon(
                    Icons.two_wheeler,
                    color: Colors.white,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blueAccent),
                ),
                ElevatedButton(
                  onPressed: () {
                    type = 'CAR';
                    print(type);
                  },
                  child: Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blueAccent),
                ),
              ],
            ),
          ],
        ),
      ),
      textConfirm: 'Add',
      onConfirm: () {
        addVehicle(
          name,
          numberPlate,
          vehicleModel,
          vehicleColor,
          type,
        );
        addNewVehicle(name, numberPlate, vehicleModel, vehicleColor, type);
        Get.back();
      },
      textCancel: 'Cancel',
    );
  }

  @override
  Widget build(BuildContext context) {
    var vehicles = <dynamic>[];
    var userBox;
    RxList<dynamic> vehiclesRx;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blueAccent,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1331&q=80',
                ),
                backgroundColor: Colors.green,
              )),
          SizedBox(height: 20),
          Text(
            profilescreenController.profileData.value!['username'],
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Your Vehicles',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Obx(
              () {
                userBox = Hive.box('userBox');
                vehicles = userBox.get('vehicle');
                vehiclesRx = vehicles.obs;
                return ListView.builder(
                  itemCount: vehiclesRx.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehiclesRx[index];
                    final titleText = vehicle['brand_name'];
                    final subtitleText = vehicle['vehicle_model'];
                    return ListTile(
                      title: Text(titleText),
                      subtitle: Text(subtitleText),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addVehicle,
            child: Text('Add Vehicle'),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
