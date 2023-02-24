import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

Future<Map<String, dynamic>> fetchUserData() async {
  final temp = 'Bearer ' + Globals.access_token;
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/user/retrieve/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': temp
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to retrieve user data');
  }
}
