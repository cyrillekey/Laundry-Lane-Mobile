// To parse this JSON data, do
//
//     final serviceType = serviceTypeFromJson(jsonString);

import 'dart:convert';

List<ServiceType> serviceTypeFromJson(String str) => List<ServiceType>.from(
  json.decode(str).map((x) => ServiceType.fromJson(x)),
);

String serviceTypeToJson(List<ServiceType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceType {
  int id;
  String? name;
  String? description;
  num price;
  String? serviceTimelines;
  DateTime? createdat;
  DateTime? updatedat;

  ServiceType({
    required this.id,
    this.name,
    this.description,
    required this.price,
    this.serviceTimelines,
    this.createdat,
    this.updatedat,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    serviceTimelines: json["serviceTimelines"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "serviceTimelines": serviceTimelines,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
