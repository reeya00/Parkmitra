import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<List<LatLng>> getDirections(double startLat, double startLng, double endLat, double endLng,points) async {
  var url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248586d876972c54da6ad557c1579ffe80c&start=$startLng,$startLat&end=$endLng,$endLat');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var geometry = data['features'][0]['geometry']['coordinates'];
    // List<LatLng> points = [];

    for (var i = 0; i < geometry.length; i++) {
      points.add(LatLng(geometry[i][1], geometry[i][0]));
    }
    print(points);
    return points;
  } else {
    throw Exception('Failed to get directions');
  }
}

