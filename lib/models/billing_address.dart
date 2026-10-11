import 'dart:convert';

BillingAddress billingAddresFromJson(String str) =>
    BillingAddress.fromJson(json.decode(str));

String billingAddresToJson(BillingAddress data) => json.encode(data.toJson());

class BillingAddress {
  final int id;
  final int userId;
  final String recipientName;
  final String? phone;
  final String email;
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? taxId;
  final DateTime createdat;
  final DateTime updatedat;

  BillingAddress({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.email,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.taxId,
    required this.createdat,
    required this.updatedat,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
    id: json["id"],
    userId: json["userId"],
    recipientName: json["recipientName"],
    phone: json["phone"],
    email: json["email"],
    street: json["street"],
    city: json["city"],
    state: json["state"],
    zipCode: json["zipCode"],
    country: json["country"],
    taxId: json["taxId"],
    createdat: DateTime.parse(json["createdat"]),
    updatedat: DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "recipientName": recipientName,
    "phone": phone,
    "email": email,
    "street": street,
    "city": city,
    "state": state,
    "zipCode": zipCode,
    "country": country,
    "taxId": taxId,
    "createdat": createdat.toIso8601String(),
    "updatedat": updatedat.toIso8601String(),
  };
}
