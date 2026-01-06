// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:jiffy/jiffy.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? email;
  String? name;
  String? phone;
  String? role;
  DateTime? lastLoginDate;
  DateTime? dateOfBirth;
  String? userName;
  String? gender;
  String? avatar;
  DateTime? createdat;
  DateTime? updatedat;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.role,
    this.lastLoginDate,
    this.dateOfBirth,
    this.userName,
    this.avatar,
    this.gender,
    this.createdat,
    this.updatedat,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    phone: json["phone"],
    role: json["role"],
    gender: json['gender'],
    lastLoginDate:
        json["lastLoginDate"] == null
            ? null
            : Jiffy.parse(json["lastLoginDate"]).dateTime,
    dateOfBirth:
        json["dateOfBirth"] == null || json["dateOfBirth"] == ""
            ? null
            : Jiffy.parse(json["dateOfBirth"]).dateTime,
    userName: json["userName"],
    avatar: json["avatar"],
    createdat:
        json["createdat"] == null
            ? null
            : Jiffy.parse(json["createdat"], isUtc: true).dateTime,
    updatedat:
        json["updatedat"] == null
            ? null
            : Jiffy.parse((json["updatedat"]), isUtc: true).dateTime,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "phone": phone,
    "role": role,
    "lastLoginDate": lastLoginDate?.toIso8601String(),
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "userName": userName,
    "avatar": avatar,
    "gender": gender,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
