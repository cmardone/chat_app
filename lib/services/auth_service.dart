import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/globals/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';

class AuthService extends ChangeNotifier {
  User _user;
  bool _isLoggingIn = false;

  final _storage = new FlutterSecureStorage();

  User get user => _user;

  bool get isLoggingIn => _isLoggingIn;

  Future<bool> login(String email, String password) async {
    _isLoggingIn = true;
    notifyListeners();
    final data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      '${Environment.apiUrl}/login',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _isLoggingIn = false;
    notifyListeners();
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      _user = loginResponse.user;
      await _storage.write(key: 'jwt_token', value: loginResponse.token);
      return true;
    }
    return false;
  }

  Future logout() async {
    _user = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }

  Future register(String name, String email, String password) async {
    _isLoggingIn = true;
    notifyListeners();
    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      '${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _isLoggingIn = false;
    notifyListeners();
    if (response.statusCode == 201) {
      final loginResponse = loginResponseFromJson(response.body);
      _user = loginResponse.user;
      await _storage.write(key: 'jwt_token', value: loginResponse.token);
      return true;
    }
    final obj = jsonDecode(response.body);
    return obj['msg'];
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.get(
      '${Environment.apiUrl}/login/refresh_token',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    final obj = jsonDecode(response.body);
    if (obj['ok']) {
      final loginResponse = loginResponseFromJson(response.body);
      _user = loginResponse.user;
      await _storage.write(key: 'jwt_token', value: loginResponse.token);
      return true;
    } else {
      await logout();
      return false;
    }
  }

  static Future<String> getJwtToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: 'jwt_token');
  }
}
