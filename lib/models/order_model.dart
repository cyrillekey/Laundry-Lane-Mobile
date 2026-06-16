import 'dart:convert';

import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/service_model.dart';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int id;
  DateTime date;
  DateTime? pickupDate;
  String? pickupTime;
  String orderStatus;
  String orderType;
  String? deliveryWindow;
  String? instructions;
  dynamic weight;
  String? washType;
  int? deliveryFee;
  int total;
  int? productCatalogId;
  int userId;
  dynamic deliveryZoneId;
  int? serviceTypeId;
  dynamic addressId;
  DateTime? createdat;
  DateTime? updatedat;
  ServiceType? serviceType;
  Catalog? productCatalog;
  int? itemsCount;

  Order({
    required this.id,
    required this.date,
    this.pickupDate,
    this.pickupTime,
    required this.orderStatus,
    required this.orderType,
    this.deliveryWindow,
    this.instructions,
    this.weight,
    this.washType,
    this.deliveryFee,
    required this.total,
    this.productCatalogId,
    required this.userId,
    this.deliveryZoneId,
    this.serviceTypeId,
    this.addressId,
    this.createdat,
    this.updatedat,
    this.serviceType,
    this.productCatalog,
    this.itemsCount,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
    pickupDate:
        json["pickupDate"] == null ? null : DateTime.parse(json["pickupDate"]),
    pickupTime: json["pickupTime"],
    orderStatus: json["orderStatus"],
    orderType: json["orderType"],
    deliveryWindow: json["deliveryWindow"],
    instructions: json["instructions"],
    weight: json["weight"],
    washType: json["washType"],
    deliveryFee: json["deliveryFee"],
    total: json["total"],
    productCatalogId: json["productCatalogId"],
    userId: json["userId"],
    deliveryZoneId: json["deliveryZoneId"],
    serviceTypeId: json["serviceTypeId"],
    addressId: json["addressId"],
    itemsCount: json["itemsCount"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
    serviceType:
        json["serviceType"] == null
            ? null
            : ServiceType.fromJson(json["serviceType"]),
    productCatalog:
        json["productCatalog"] == null
            ? null
            : Catalog.fromJson(json["productCatalog"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date.toIso8601String(),
    "pickupDate": pickupDate?.toIso8601String(),
    "pickupTime": pickupTime,
    "orderStatus": orderStatus,
    "orderType": orderType,
    "deliveryWindow": deliveryWindow,
    "instructions": instructions,
    "weight": weight,
    "washType": washType,
    "deliveryFee": deliveryFee,
    "total": total,
    "productCatalogId": productCatalogId,
    "userId": userId,
    "deliveryZoneId": deliveryZoneId,
    "serviceTypeId": serviceTypeId,
    "addressId": addressId,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
    "serviceType": serviceType?.toJson(),
    "productCatalog": productCatalog?.toJson(),
  };
}
