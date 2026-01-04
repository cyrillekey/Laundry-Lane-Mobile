// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int? id;
  DateTime? date;
  String? timeSlot;
  String? orderType;
  String? instructions;
  String? status;
  int? deliveryFee;
  int? total;
  int? userId;
  DateTime? createdat;
  DateTime? updatedat;

  Order({
    this.id,
    this.date,
    this.timeSlot,
    this.orderType,
    this.instructions,
    this.status,
    this.deliveryFee,
    this.total,
    this.userId,
    this.createdat,
    this.updatedat,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    timeSlot: json["timeSlot"],
    orderType: json["orderType"],
    instructions: json["instructions"],
    status: json["status"],
    deliveryFee: json["deliveryFee"],
    total: json["total"],
    userId: json["userId"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date?.toIso8601String(),
    "timeSlot": timeSlot,
    "orderType": orderType,
    "instructions": instructions,
    "status": status,
    "deliveryFee": deliveryFee,
    "total": total,
    "userId": userId,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
