// To parse this JSON data, do
//
//     final clothingType = clothingTypeFromJson(jsonString);

import 'dart:convert';

List<ClothingType> clothingTypeFromJson(String str) => List<ClothingType>.from(
  json.decode(str).map((x) => ClothingType.fromJson(x)),
);

String clothingTypeToJson(List<ClothingType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClothingType {
  int? id;
  String? name;
  String? type;
  int? price;
  DateTime? createdat;
  DateTime? updatedat;

  ClothingType({
    this.id,
    this.name,
    this.type,
    this.price,
    this.createdat,
    this.updatedat,
  });

  factory ClothingType.fromJson(Map<String, dynamic> json) => ClothingType(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    price: json["price"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "price": price,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
