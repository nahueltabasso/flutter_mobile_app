import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/models/http_error_dto.dart';
import 'package:techconnect_mobile/models/location_dto.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';

class UserProfileService extends ChangeNotifier {

  static final String _baseUrl = '172.17.0.1:8090';
  final storage = FlutterSecureStorage();
  UserProfileDto? _loggedUserProfile = null;

  UserProfileDto? get loggedUserProfile => _loggedUserProfile;

  set setLoggedUserProfile(UserProfileDto userProfileDto) {
    _loggedUserProfile = userProfileDto;
    notifyListeners();
  }

  Future<dynamic?> saveProfile(Map<String, dynamic> userProfileFormData, File image, BuildContext context) async {
    // Create a multipart request to send a file and data
    var request = http.MultipartRequest('POST',
      Uri.parse('http://${_baseUrl}/api/users/user-profile/add'));
    // Set Authorization header
    request.headers['Authorization'] = 'Bearer ${await storage.read(key: 'accessToken')}'; 
    // Set data to request's form data
    request = jsonToFormData(request, userProfileFormData);
    print('requests fields ${request.fields}');
    // Set image to request
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
    }
    try {
      final response = await request.send();
      final jsonResponse = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        // Successfull request, handler the response here
        print('Server Response: ${response.statusCode}');
        print(jsonResponse);
        final userProfile = UserProfileDto.fromRawJson(jsonResponse);
        setLoggedUserProfile = userProfile;
        return userProfile;
      } else {
        // Failed requst, handler the error here
        print('Request Error: ${response.statusCode}');
        print('Request Error: ${jsonResponse}');
        final error = HttpErrorDto.fromRawJson(jsonResponse);
        return error;
      }
    } catch (e) {
      print('Error : $e');
      return null;
    }
  }

  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  Future<LocationDto?> saveUserLocation(BuildContext context, LatLng position) async {
    double lat = position.latitude;
    double long = position.longitude;
    // First consume a reverse geocoding to retrieve a data from gps point
    // To do this use a Nominatim from OSM(Open Street Map) that is a open source
    // map library that offer a free geocoding APIs
    String url = 'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$long';
    final geoResponse = await http.get(Uri.parse(url));
    if (geoResponse.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(geoResponse.body);
      // Stay with address object from responseData
      responseData = responseData["address"];
      // Build request body
      Map<String, dynamic> userProfileMap = {"id": loggedUserProfile!.id, "userId": loggedUserProfile!.userId};
      Map<String, dynamic> body = {
        "id": null,
        "city": responseData["city"] ?? 'Ciudad no revelada',
        "state": responseData["state"] ?? 'Provincia no revelada',
        "country": responseData["country"] ?? 'Pais no revelado',
        "postalCode": responseData["postcode"],
        "address": responseData["road"] ?? 'Calle' + " " + responseData["house_number"] ?? '',
        "latitude": position.latitude,
        "longitude": position.longitude,
        "userProfileDTO": userProfileMap,
        // coordinate: null
      };
      // Request headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await storage.read(key: 'accessToken')}'
      };
      String bodyStr = json.encode(body);
      final url = Uri.http(_baseUrl, '/api/users/location');
      final response = await http.post(url, headers: headers, body: bodyStr);
      if (response.statusCode == 201) {
        var locationDto = LocationDto.fromRawJson(response.body);
        return locationDto;
      }
      
      // In this point happened an error
      print('Error on request: ${response.statusCode}');
      print(response.body);
      final error = HttpErrorDto.fromRawJson(response.body);
      DialogService.showErrorDialogAlert(context, error.message);
      return null;
    } else {
      DialogService.showErrorDialogAlert(context, CommonConstant.LOCATION_NOT_VALID);
      return null;
    }
  }




}