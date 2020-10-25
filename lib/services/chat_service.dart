import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/globals/environment.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier {
  User _toUser;
  List<Message> _messages = [];

  User get toUser => _toUser;

  Future setUser(User value) async {
    _toUser = value;
    await getMessages(); //.then((_) => notifyListeners());
    notifyListeners();
  }

  List<Message> get messages => _messages;

  Future getMessages() async {
    final token = await AuthService.getJwtToken();
    final response = await http.get(
      '${Environment.apiUrl}/messages/${_toUser.id}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final messagesReponse = messagesReponseFromJson(response.body);
      _messages = messagesReponse.messages;
    } else {
      print(response.statusCode);
      _messages = [];
    }
  }
}
