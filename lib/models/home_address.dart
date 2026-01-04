// To parse this JSON data, do
//
//     final homeAddress = homeAddressFromJson(jsonString);

import 'dart:convert';

HomeAddress homeAddressFromJson(String str) =>
    HomeAddress.fromJson(json.decode(str));

String homeAddressToJson(HomeAddress data) => json.encode(data.toJson());

class HomeAddress {
  int? id;
  int? userId;
  double? latitude;
  double? longitude;
  String? type;
  String? houseNo;
  String? recipientName;
  String? recipientPhone;
  String? landmark;
  String? street;
  DateTime? createdat;
  DateTime? updatedat;

  HomeAddress({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.type,
    this.houseNo,
    this.recipientName,
    this.recipientPhone,
    this.landmark,
    this.street,
    this.createdat,
    this.updatedat,
  });

  factory HomeAddress.fromJson(Map<String, dynamic> json) => HomeAddress(
    id: json["id"],
    userId: json["userId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    type: json["type"],
    houseNo: json["houseNo"],
    recipientName: json["recipientName"],
    recipientPhone: json["recipientPhone"],
    landmark: json["landmark"],
    street: json["street"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "latitude": latitude,
    "longitude": longitude,
    "type": type,
    "houseNo": houseNo,
    "recipientName": recipientName,
    "recipientPhone": recipientPhone,
    "landmark": landmark,
    "street": street,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
