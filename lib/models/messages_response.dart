// To parse this JSON data, do
//
//     final messagesReponse = messagesReponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/message.dart';

MessagesReponse messagesReponseFromJson(String str) =>
    MessagesReponse.fromJson(json.decode(str));

String messagesReponseToJson(MessagesReponse data) =>
    json.encode(data.toJson());

class MessagesReponse {
  MessagesReponse({
    this.ok,
    this.messages,
  });

  bool ok;
  List<Message> messages;

  factory MessagesReponse.fromJson(Map<String, dynamic> json) =>
      MessagesReponse(
        ok: json["ok"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}
