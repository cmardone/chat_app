import 'dart:convert';

import 'package:chat_app/models/user.dart';

UsersReponse usersReponseFromJson(String str) =>
    UsersReponse.fromJson(json.decode(str));

String usersReponseToJson(UsersReponse data) => json.encode(data.toJson());

class UsersReponse {
  UsersReponse({
    this.ok,
    this.users,
  });

  bool ok;
  List<User> users;

  factory UsersReponse.fromJson(Map<String, dynamic> json) => UsersReponse(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
