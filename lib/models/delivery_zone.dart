// To parse this JSON data, do
//
//     final deliveryZone = deliveryZoneFromJson(jsonString);

import 'dart:convert';

List<DeliveryZone> deliveryZoneFromJson(String str) => List<DeliveryZone>.from(
  json.decode(str).map((x) => DeliveryZone.fromJson(x)),
);

String deliveryZoneToJson(List<DeliveryZone> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveryZone {
  int? id;
  String? name;
  String? location;
  double? latitude;
  double? longitude;
  int? radius;
  int? price;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? createdat;
  DateTime? updatedat;

  DeliveryZone({
    this.id,
    this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.radius,
    this.price,
    this.startTime,
    this.endTime,
    this.createdat,
    this.updatedat,
  });

  factory DeliveryZone.fromJson(Map<String, dynamic> json) => DeliveryZone(
    id: json["id"],
    name: json["name"],
    location: json["location"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    radius: json["radius"],
    price: json["price"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "radius": radius,
    "price": price,
    "startTime": startTime,
    "endTime": endTime,
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
