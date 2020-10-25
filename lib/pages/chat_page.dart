import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;
  List<ChatMessage> _messages = <ChatMessage>[];
  AuthService authService;
  ChatService chatService;
  SocketService socketService;

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.newMessage = (Map<String, dynamic> payload) =>
        _addMessage(payload['from'], payload['message']);
    _messages = chatService.messages
        .map(
          (item) => ChatMessage(
            text: item.message,
            userId: item.from,
            controller: AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 0),
            )..forward(),
          ),
        )
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    socketService.newMessage = null;
    _messages.forEach((element) => element.controller.dispose());
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _chatAppBar(chatService.toUser.name),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) =>
                    _messages[index],
                physics: BouncingScrollPhysics(),
                reverse: true,
              ),
            ),
            Divider(height: 1),
            _buildChatInput()
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _chatSubmitHandle,
                  onChanged: (value) => setState(() {
                    _isWriting = (value.length > 0);
                  }),
                  decoration:
                      InputDecoration.collapsed(hintText: 'Ingrese mensaje'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Platform.isIOS
                    ? CupertinoButton(
                        child: Text('Enviar'),
                        onPressed: _isWriting
                            ? () => _chatSubmitHandle(_textController.text)
                            : null,
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            icon: Icon(Icons.send),
                            onPressed: _isWriting
                                ? () => _chatSubmitHandle(_textController.text)
                                : null,
                            splashColor: Colors.transparent,
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _chatAppBar(String name) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1,
      title: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(name.toUpperCase().substring(0, 1),
                style: TextStyle(fontSize: 12)),
            maxRadius: 15,
          ),
          SizedBox(height: 3),
          Text(name, style: TextStyle(color: Colors.black87, fontSize: 12))
        ],
      ),
    );
  }

  _chatSubmitHandle(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    _addMessage(authService.user.id, text);
    setState(() => _isWriting = false);
    socketService.sendMessage({
      'to': chatService.toUser.id,
      'from': authService.user.id,
      'message': text
    });
  }

  _addMessage(String uid, String text) {
    final message = ChatMessage(
      userId: uid,
      text: text,
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, message);
    message.controller.forward();
  }
}
