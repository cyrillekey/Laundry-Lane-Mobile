// To parse this JSON data, do
//
//     final chatMessage = chatMessageFromJson(jsonString);

import 'dart:convert';

ChatMessage chatMessageFromJson(String str) =>
    ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  final int? id;
  final String? message;
  final bool? read;
  final int? senderId;
  final int? chatsessionId;
  final List<String>? attachments;
  final DateTime? createdat;
  final DateTime? updatedat;

  ChatMessage({
    this.id,
    this.message,
    this.read,
    this.senderId,
    this.chatsessionId,
    this.attachments,
    this.createdat,
    this.updatedat,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json["id"],
    message: json["message"],
    read: json["read"],
    senderId: json["senderId"],
    chatsessionId: json["chatsessionId"],
    attachments:
        json["attachments"] == null
            ? []
            : List<String>.from(json["attachments"]!.map((x) => x)),
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "read": read,
    "senderId": senderId,
    "chatsessionId": chatsessionId,
    "attachments":
        attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x)),
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
