// To parse this JSON data, do
//
//     final paymentCard = paymentCardFromJson(jsonString);

import 'dart:convert';

List<PaymentCard> paymentCardFromJson(String str) => List<PaymentCard>.from(
  json.decode(str).map((x) => PaymentCard.fromJson(x)),
);

String paymentCardToJson(List<PaymentCard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentCard {
  String? cardNo;
  String? expiryDate;
  String? name;
  String? number;
  int? id;
  DateTime? createdat;
  DateTime? updatedat;
  String? brand;
  int? userId;
  bool? isDefault;

  PaymentCard({
    this.cardNo,
    this.expiryDate,
    this.name,
    this.id,
    this.createdat,
    this.updatedat,
    this.brand,
    this.userId,
    this.isDefault,
    this.number,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
    cardNo: json["cardNo"],
    expiryDate: json["expiryDate"],
    name: json["name"],
    number: json['number'],
    id: json["id"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
    brand: json["brand"],
    userId: json["userId"],
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "cardNo": cardNo,
    "expiryDate": expiryDate,
    "name": name,
    "id": id,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
    "brand": brand,
    "userId": userId,
    "isDefault": isDefault,
  };
}
