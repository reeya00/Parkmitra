import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _vehicles = <Vehicle>[].obs;

  var listitems = [
    'BIKE',
    'CAR',
    'VAN',
    'JEEP',
  ];
  String dropdownvalue = 'BIKE';

  Future<void> addNewVehicle(
    String name,
    String numberPlate,
    String vehicleModel,
    String vehicleColor,
    String dropdownval,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/parkmitra/addvehicle/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "vehicle_type": dropdownval,
          "brand_name": name,
          "vehicle_model": vehicleModel,
          "color": vehicleColor,
          "plate_number": numberPlate,
          "owner": "4"
        }),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
      } else {
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
        height: 250,
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
            Container(
              height: 50,
              child: DropdownButton<String>(
                value: dropdownvalue,
                onChanged: (String? newvalue) {
                  setState(() {
                    dropdownvalue = newvalue.toString();
                    print(dropdownvalue);
                  });
                },
                items: listitems.map((String dropdownitem) {
                  return DropdownMenuItem<String>(
                    value: dropdownitem,
                    child: Text(dropdownitem),
                  );
                }).toList(),
              ),
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
          dropdownvalue,
        );
        addNewVehicle(
            name, numberPlate, vehicleModel, vehicleColor, dropdownvalue);
        Get.back();
      },
      textCancel: 'Cancel',
    );
  }

  @override
  Widget build(BuildContext context) {
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
            'Username',
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
              () => ListView.builder(
                itemCount: _vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _vehicles[index];
                  return ListTile(
                    title: Text(vehicle.name),
                    subtitle: Text(vehicle.numberPlate),
                  );
                },
              ),
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
