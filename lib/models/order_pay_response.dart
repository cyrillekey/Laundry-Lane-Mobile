import 'dart:convert';

OrderPayResponse orderPayResponseFromJson(String str) =>
    OrderPayResponse.fromJson(json.decode(str));

String orderPayResponseToJson(OrderPayResponse data) =>
    json.encode(data.toJson());

class OrderPayResponse {
  final int? id;
  final bool? success;
  final String? message;
  final PaymentStatus? status;
  final Paystack? paystack;

  OrderPayResponse({
    this.id,
    this.success,
    this.message,
    this.status,
    this.paystack,
  });

  factory OrderPayResponse.fromJson(Map<String, dynamic> json) =>
      OrderPayResponse(
        id: json["id"],
        success: json["success"],
        message: json["message"],
        status: PaymentStatus.fromString(json["status"]),
        paystack:
            json["paystack"] == null
                ? null
                : Paystack.fromJson(json["paystack"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "success": success,
    "message": message,
    "status": status,
    "paystack": paystack?.toJson(),
  };
}

class Paystack {
  final String? accessToken;
  final String? publicKey;
  final String? accessUrl;

  Paystack({this.accessToken, this.publicKey, this.accessUrl});

  factory Paystack.fromJson(Map<String, dynamic> json) => Paystack(
    accessToken: json["accessToken"],
    publicKey: json["publicKey"],
    accessUrl: json["accessUrl"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "publicKey": publicKey,
    "accessUrl": accessUrl,
  };
}

enum PaymentStatus {
  pending("PENDING"),
  failed("FAILED"),
  cancelled("CANCELLED"),
  successfull("SUCCESSFULL");

  const PaymentStatus(this.name);
  final String name;

  static PaymentStatus fromString(String status) {
    return PaymentStatus.values.firstWhere((element) => element.name == status);
  }
}
