import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/models/new_user_dto.dart';
import 'package:techconnect_mobile/models/password_dto.dart';
import 'package:techconnect_mobile/models/user_dto.dart';

class AuthService extends ChangeNotifier {

  static final String _baseUrl = '172.17.0.1:8090';
  UserDto? _userDto = null;

  UserDto? get userDto => _userDto;

  set setUserDto(UserDto userDto) {
    _userDto = userDto;
    notifyListeners();
  }

  Future<String?> signUp(NewUserDto userDto) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final url = Uri.http(_baseUrl, '/api/security/auth/sign-up');
    final response = await http.post(url, headers: headers, body: json.encode(userDto));
    final Map<String, dynamic> decodeResponse = json.decode(response.body);
    print(response.statusCode);
    print(decodeResponse);
    if (decodeResponse.containsKey("httpStatus") && decodeResponse["httpStatus"] == 201) {
      return null;
    }

    if (decodeResponse.containsKey("httpStatus") && decodeResponse["httpStatus"] != 201) {
      return decodeResponse["message"];
    }

    if (decodeResponse.containsKey("password")) {
      return CommonConstant.NOT_VALID_PASSWORD;
    }
    return null;
  }

  // Endpoint to Login
  Future<String?> signIn(String username, String password) async {
    print("Enter to signUp()");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {"username": username, "password": password};

    print(body);
    final url = Uri.http(_baseUrl, '/api/security/auth/sign-in');
    final response = await http.post(url, headers: headers, body: json.encode(body));
    final Map<String, dynamic> decodeResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final user = UserDto.fromRawJson(response.body);
      setUserDto = user;
      // _saveInStorage(decodeResponse);
      return null;
    }

    if (decodeResponse["errorCode"] == 'BAD_CREDENTIALS') {
      return CommonConstant.BAD_CREDENTIALS;
    }

    if (decodeResponse["errorCode"] == 'USER_LOCKED') {
      return CommonConstant.USER_LOCKED;
    }
    return "";
  }

  Future<String?> forgotPassword(String email) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final url = Uri.http(_baseUrl, '/api/security/password/forgot-password', {'email': email});
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) return null;
    // If gets to this part means that an error occurred, so decode the body of response
    final Map<String, dynamic> decodeResponse = json.decode(response.body);
    if (decodeResponse.containsKey("errorCode")) return decodeResponse["message"];

    return null;
  }

  Future<String?> resetPassword(PasswordDTO passwordDTO) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final url = Uri.http(_baseUrl, '/api/security/password/reset-password');
    final response = await http.post(url, headers: headers, body: json.encode(passwordDTO));
    if (response.statusCode == 200) return null;
    // If gets to this part means that an error occurred, so decode the body of response
    final Map<String, dynamic> decodeResponse = json.decode(response.body);
    if (decodeResponse.containsKey("errorCode")) return decodeResponse["message"];

    return null;
  }

}

