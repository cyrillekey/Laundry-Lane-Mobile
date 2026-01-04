// To parse this JSON data, do
//
//     final catalog = catalogFromJson(jsonString);

import 'dart:convert';

List<Catalog> catalogFromJson(String str) =>
    List<Catalog>.from(json.decode(str).map((x) => Catalog.fromJson(x)));

String catalogToJson(List<Catalog> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Catalog {
  int? id;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  List<String>? services;
  bool? bulk;
  DateTime? createdat;
  DateTime? updatedat;

  Catalog({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.services,
    this.createdat,
    this.updatedat,
    this.bulk,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: double.tryParse(json["price"].toString()) ?? 0.0,
    imageUrl: json["imageUrl"],
    bulk: json["bulk"],
    services:
        json["services"] == null
            ? []
            : List<String>.from(json["services"]!.map((x) => x)),
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
    "imageUrl": imageUrl,

    "services":
        services == null ? [] : List<dynamic>.from(services!.map((x) => x)),
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
