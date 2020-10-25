import 'package:chat_app/globals/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  Function _newMessage;

  ServerStatus get serverStatus => _serverStatus;

  set newMessage(Function value) {
    _newMessage = value;
    //notifyListeners();
  }

  Future connect() async {
    final token = await AuthService.getJwtToken();
    // Dart client
    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'Authorization': 'Bearer $token'}
    });

    _socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('new-message', (payload) {
      if (_newMessage != null) {
        _newMessage(payload);
        notifyListeners();
      }
    });

    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

  void sendMessage(Map<String, String> payload) {
    _socket.emit('new-message', payload);
  }
}
