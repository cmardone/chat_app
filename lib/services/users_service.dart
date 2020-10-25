import 'package:chat_app/models/users_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/globals/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/user.dart';

class UsersService with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  UsersService() {
    getUsers();
  }

  Future getUsers() async {
    final token = await AuthService.getJwtToken();
    final response = await http.get(
      '${Environment.apiUrl}/users',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final usersResponse = usersReponseFromJson(response.body);
      _users = usersResponse.users;
    } else {
      print(response.statusCode);
      _users = [];
    }
    notifyListeners();
  }
}
