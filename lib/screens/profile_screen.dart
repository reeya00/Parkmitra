import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, String>> _vehicles = [];

  void _addVehicle() async {
    Map<String, String>? newVehicle = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String numberPlate = '';

        return AlertDialog(
          title: const Text('Add Vehicle'),
          content: SizedBox(
            height: 150,
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
                };
                Navigator.pop(context, newVehicle);
              },
              child: const Text('Save'),
            ),
          ],
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
          return ListTile(
            title: Text(_vehicles[index]['name']!),
            subtitle: Text(_vehicles[index]['numberPlate']!),
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
