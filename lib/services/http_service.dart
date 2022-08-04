import 'dart:convert';

import 'package:http/http.dart';

import 'package:geolocator/geolocator.dart';

class HttpService {
  
  Future<dynamic> getReply(int id, dynamic selected_option) async {
    final url = Uri.parse("http://49.50.74.106:3001/chatbot/chat/${id}?selected_option=${selected_option.toString().replaceAll("&", "^")}");
    
    print(url);
    final headers = {
      'Content-Type': 'application/json',
      //    'Authorization': token.toString()
    };

    var response = await get(url, headers: headers);
    int statusCode = response.statusCode;

    print(response.statusCode);

    if (response.statusCode == 200) {
      String responseBody = response.body;

      dynamic _jsondata = jsonDecode(responseBody);
     
     print(_jsondata);
      return _jsondata;
    } else {
      return [];
    }
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
