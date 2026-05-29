import 'dart:convert';

List<Stores> storesFromJson(String str) =>
    List<Stores>.from(json.decode(str).map((x) => Stores.fromJson(x)));

String storesToJson(List<Stores> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stores {
  final int id;
  final String name;
  final num rating;
  final String? logo;
  final String location;
  final num latitude;
  final num longitude;
  final num radius;
  final String opening;
  final String closing;
  final List<int> daysOff;
  final int organisationId;
  final DateTime createdat;
  final DateTime updatedat;

  Stores({
    required this.id,
    required this.name,
    required this.rating,
    this.logo,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.opening,
    required this.closing,
    required this.daysOff,
    required this.organisationId,
    required this.createdat,
    required this.updatedat,
  });

  factory Stores.fromJson(Map<String, dynamic> json) => Stores(
    id: json["id"],
    name: json["name"],
    rating: json["rating"],
    logo: json["logo"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    radius: json["radius"],
    opening: json["opening"],
    closing: json["closing"],
    daysOff: List<int>.from(json["daysOff"].map((x) => x)),
    organisationId: json["organisationId"],
    createdat: DateTime.parse(json["createdat"]),
    updatedat: DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "rating": rating,
    "logo": logo,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "radius": radius,
    "opening": opening,
    "closing": closing,
    "daysOff": List<dynamic>.from(daysOff.map((x) => x)),
    "organisationId": organisationId,
    "createdat": createdat.toIso8601String(),
    "updatedat": updatedat.toIso8601String(),
  };
}
