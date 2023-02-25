import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, String>> _vehicles = [];

  void addNewVehicle(name, numberPlate, vehicleModel, vehicleColor) async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/parkmitra/addvehicle/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "vehicle_type": "BIKE",
          "brand_name": name,
          "vehicle_model": vehicleModel,
          "color": vehicleColor,
          "plate_number": numberPlate,
          "owner": "4"
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String errorMessage = responseData['detail'];
      throw Exception(errorMessage);
    }
  }

  void _addVehicle() async {
    Map<String, String>? newVehicle = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String numberPlate = '';
        String vehicleColor = '';
        String vehicleModel = '';
        var items = [
          'BIKE',
          'CAR',
          'VAN',
          'JEEP',
        ];
        String dropdownvalue = 'BIKE';

        return Container(
          child: AlertDialog(
            title: const Text('Add Vehicle'),
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
                  DropdownButton(
                    // Initial Value
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Map<String, String> newVehicle = {
                    'name': name,
                    'numberPlate': numberPlate,
                    'vehicleModel': vehicleModel,
                    'vehicleColor': vehicleColor,
                  };
                  addNewVehicle(name, numberPlate, vehicleModel, vehicleColor);
                  Navigator.pop(context, newVehicle);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    if (newVehicle != null) {
      setState(() {
        _vehicles.add(newVehicle);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _vehicles.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.blue.shade100,
            child: ListTile(
              title: Text(_vehicles[index]['name']!),
              subtitle: Text(_vehicles[index]['numberPlate']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVehicle,
        tooltip: 'Add Vehicle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
