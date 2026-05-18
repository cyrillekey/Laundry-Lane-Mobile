// To parse this JSON data, do
//
//     final appNotification = appNotificationFromJson(jsonString);

import 'dart:convert';

List<AppNotification> appNotificationFromJson(String str) =>
    List<AppNotification>.from(
      json.decode(str).map((x) => AppNotification.fromJson(x)),
    );

String appNotificationToJson(List<AppNotification> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppNotification {
  int? id;
  String? title;
  String? message;
  bool? read;
  String? ref;
  String? attachment;
  int? userId;
  String? createdat;
  String? updatedat;

  AppNotification({
    this.id,
    this.title,
    this.message,
    this.read,
    this.ref,
    this.attachment,
    this.userId,
    this.createdat,
    this.updatedat,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        read: json["read"],
        ref: json["ref"],
        attachment: json["attachment"],
        userId: json["userId"],
        createdat: json["createdat"],
        updatedat: json["updatedat"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "read": read,
    "ref": ref,
    "attachment": attachment,
    "userId": userId,
    "createdat": createdat,
    "updatedat": updatedat,
  };
}
