// To parse this JSON data, do
//
//     final chatSession = chatSessionFromJson(jsonString);

import 'dart:convert';

import 'package:laundrylane/models/chat_message.dart';

List<ChatSession> chatSessionFromJson(String str) => List<ChatSession>.from(
  json.decode(str).map((x) => ChatSession.fromJson(x)),
);

String chatSessionToJson(List<ChatSession> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatSession {
  final int? id;
  final DateTime? createdat;
  final DateTime? updatedat;
  final int unreadCount;
  final List<ChatMember>? members;
  final ChatMessage? lastMessage;

  ChatSession({
    this.id,
    this.createdat,
    this.updatedat,
    this.members,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json["id"],
    unreadCount: json["unreadCount"] ?? 0,
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
    members:
        json["members"] == null
            ? []
            : List<ChatMember>.from(
              json["members"]!.map((x) => ChatMember.fromJson(x)),
            ),
    lastMessage:
        json["lastMessage"] == null
            ? null
            : ChatMessage.fromJson(json["lastMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
    "members":
        members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
    "lastMessage": lastMessage?.toJson(),
  };
}

class ChatMember {
  final int? id;
  final int? userId;
  final User? user;

  ChatMember({this.id, this.userId, this.user});

  factory ChatMember.fromJson(Map<String, dynamic> json) => ChatMember(
    id: json["id"],
    userId: json["userId"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? phone;
  final String? userName;

  User({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.phone,
    this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    phone: json["phone"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar": avatar,
    "phone": phone,
    "userName": userName,
  };
}
