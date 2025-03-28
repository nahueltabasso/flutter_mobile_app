import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:techconnect_mobile/models/http_error_dto.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';

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



}