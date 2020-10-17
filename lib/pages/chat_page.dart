import 'dart:io';
import 'dart:math';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;
  final _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _chatAppBar(),
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

  AppBar _chatAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1,
      title: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text('C', style: TextStyle(fontSize: 12)),
            maxRadius: 15,
          ),
          SizedBox(height: 3),
          Text('Cristóbal Mardones Bucarey',
              style: TextStyle(color: Colors.black87, fontSize: 12))
        ],
      ),
    );
  }

  _chatSubmitHandle(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    final rnd = Random();
    final message = ChatMessage(
      userId: rnd.nextBool() ? '123' : '321',
      text: text,
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, message);
    message.controller.forward();
    setState(() => _isWriting = false);
  }

  @override
  void dispose() {
    // TODO: Socket disconnect
    _messages.forEach((element) => element.controller.dispose());
    _textController.dispose();
    super.dispose();
  }
}
