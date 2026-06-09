import 'dart:convert';

List<StorePaymentMethod> storePaymentMethodFromJson(String str) =>
    List<StorePaymentMethod>.from(
      json.decode(str).map((x) => StorePaymentMethod.fromJson(x)),
    );

String storePaymentMethodToJson(List<StorePaymentMethod> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StorePaymentMethod {
  final int id;
  final int paymentMethodId;
  final int storeId;
  final PaymentMethod paymentMethod;

  StorePaymentMethod({
    required this.id,
    required this.paymentMethodId,
    required this.storeId,
    required this.paymentMethod,
  });

  factory StorePaymentMethod.fromJson(Map<String, dynamic> json) =>
      StorePaymentMethod(
        id: json["id"],
        paymentMethodId: json["paymentMethodId"],
        storeId: json["storeId"],
        paymentMethod: PaymentMethod.fromJson(json["paymentMethod"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "paymentMethodId": paymentMethodId,
    "storeId": storeId,
    "paymentMethod": paymentMethod.toJson(),
  };
}

class PaymentMethod {
  final int id;
  final String name;
  final dynamic description;
  final dynamic icon;
  final ProviderType type;

  PaymentMethod({
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    icon: json["icon"],
    type: ProviderType.fromString(json['type']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "icon": icon,
  };
}

enum ProviderType {
  cash("CASH"),
  card("CARD"),
  mobile("MOBILE"),
  offline("OFFLINE");

  final String name;
  const ProviderType(this.name);
  static ProviderType fromString(String status) {
    return ProviderType.values.firstWhere((element) => element.name == status);
  }
}
