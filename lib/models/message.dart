class Message {
  Message({
    this.to,
    this.from,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  String to;
  String from;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        to: json["to"],
        from: json["from"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "from": from,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
