import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String userId;
  final AnimationController controller;

  const ChatMessage({
    Key key,
    @required this.text,
    @required this.userId,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return FadeTransition(
      opacity: controller,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: controller, curve: Curves.easeOut),
        child: Container(
          child: userId == authService.user.id
              ? _buildSentMessage()
              : _buildReceivedMessage(),
        ),
      ),
    );
  }

  Widget _buildSentMessage() => Align(
        alignment: Alignment.centerRight,
        child: Container(
          child: Text(text, style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xff4d9ef6),
          ),
          margin: EdgeInsets.only(left: 50, bottom: 5, right: 5),
          padding: EdgeInsets.all(8),
        ),
      );

  Widget _buildReceivedMessage() => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          child: Text(text, style: TextStyle(color: Colors.black87)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xffe4e5e8),
          ),
          margin: EdgeInsets.only(left: 5, bottom: 5, right: 50),
          padding: EdgeInsets.all(8),
        ),
      );
}
