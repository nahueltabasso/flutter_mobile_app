import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/models/friend_request_dto.dart';
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

  Future<LocationDto?> saveUserLocation(LatLng position) async {
    double lat = position.latitude;
    double long = position.longitude;
    // First consume a reverse geocoding to retrieve a data from gps point
    // To do this use a Nominatim from OSM(Open Street Map) that is a open source
    // map library that offer a free geocoding APIs
    String url = 'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$long';
    print("URL $url");
    final geoResponse = await http.get(Uri.parse(url));
    print("LLEGA ACA $geoResponse");
    print("status geo ${geoResponse.statusCode}");
    print("Body geo ${geoResponse.body}");
    if (geoResponse.statusCode == 200) {
      print("Entra a la condicion");
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
      print("Pasa el request, status ${response.statusCode}");
      if (response.statusCode == 201) {
        print("Entra al if status 201");
        var locationDto = LocationDto.fromRawJson(response.body);
        return locationDto;
      }
      
      // In this point happened an error
      print('Error on request: ${response.statusCode}');
      print(response.body);
      final error = HttpErrorDto.fromRawJson(response.body);
      // DialogService.showErrorDialogAlert(context, error.message);
      return null;
    } else {
      // DialogService.showErrorDialogAlert(context, CommonConstant.LOCATION_NOT_VALID);
      return null;
    }
  }

  Future<List<UserProfileDto>?> getPossibleFriends(int userProfileId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'accessToken')}'
    };

    final url = Uri.http(_baseUrl, '/api/users/user-profile/suggest-possible-friends/$userProfileId');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List<UserProfileDto> dtoList = (json.decode(response.body) as List)
              .map((i) => UserProfileDto.fromJson(i)).toList();

      return dtoList;
    }
    return null;
  }

  Future<UserProfileDto> getUserProfileById(int userProfileId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'accessToken')}'
    };

    final url = Uri.http(_baseUrl, '/api/users/user-profile/$userProfileId');
    final response = await http.get(url, headers: headers);

    return UserProfileDto.fromRawJson(response.body);
  }

  Future<FriendRequestDto?> sendFriendRequest(FriendRequestDto dto) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'accessToken')}'
    };

    try {
      final url = Uri.http(_baseUrl, '/api/users/friend-request');
      final response = await http.post(url, headers: headers, body: json.encode(dto));
      // Validated if the status code is correct
      if (response.statusCode == 201) {
        var friendRequestDto = FriendRequestDto.fromRawJson(response.body);
        return friendRequestDto;
      }
      // In this point happened an error
      if (response.statusCode == 500) {
        final Map<String, dynamic> error = json.decode(response.body);
        var msg = "";
        if (error["error"] == 'TO_USER_NOT_EXITS') msg = CommonConstant.TO_USER_NOT_FOUND;
        if (error["error"] == 'REQUEST_HAS_ALREADY_BEEN_SUBMITTED') msg = CommonConstant.REQUEST_HAS_ALREADY_BEEN_SUBMITTED;
        if (error["error"] == 'ALREADY_FRIENDS') msg = CommonConstant.ALREADY_FRIENDS;
        if (error["error"] == 'NOT_EXISTS_FRIEND_REQUEST') msg = CommonConstant.NOT_EXISTS_FRIEND_REQUEST;
        
        print("Error message $msg");
        // NotificationService.showInfoDialogAlert(context, 'Atencion!', msg, null);
      }
      
    } catch (e) {
      print(e);      
    }
    return null;
  }

  Future<void> getUserProfileLogged() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'accessToken')}'
    };

    final url = Uri.http(_baseUrl, '/api/users/user-profile/get-logged-user-profile');
    final response = await http.get(url, headers: headers);
    setLoggedUserProfile = UserProfileDto.fromRawJson(response.body);
  }

}
