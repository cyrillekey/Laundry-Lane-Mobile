// To parse this JSON data, do
//
//     final securityConfig = securityConfigFromJson(jsonString);

import 'dart:convert';

SecurityConfig securityConfigFromJson(String str) =>
    SecurityConfig.fromJson(json.decode(str));

String securityConfigToJson(SecurityConfig data) => json.encode(data.toJson());

class SecurityConfig {
  final int? id;
  final dynamic userId;
  final dynamic organisationId;
  final bool? twoFactorEnabled;
  final bool? enforceTwoFactor;
  final bool? loginAlerts;
  final int? maxLoginAttempts;
  final bool? requirePinOnDelivery;
  final bool? requirePinOnPickup;
  final List<String>? ipWhitelist;
  final DateTime? createdat;
  final DateTime? updatedat;

  SecurityConfig({
    this.id,
    this.userId,
    this.organisationId,
    this.twoFactorEnabled,
    this.enforceTwoFactor,
    this.loginAlerts,
    this.maxLoginAttempts,
    this.requirePinOnDelivery,
    this.requirePinOnPickup,
    this.ipWhitelist,
    this.createdat,
    this.updatedat,
  });

  factory SecurityConfig.fromJson(Map<String, dynamic> json) => SecurityConfig(
    id: json["id"],
    userId: json["userId"],
    organisationId: json["organisationId"],
    twoFactorEnabled: json["twoFactorEnabled"],
    enforceTwoFactor: json["enforceTwoFactor"],
    loginAlerts: json["loginAlerts"],
    maxLoginAttempts: json["maxLoginAttempts"],
    requirePinOnDelivery: json["requirePinOnDelivery"],
    requirePinOnPickup: json["requirePinOnPickup"],
    ipWhitelist:
        json["ipWhitelist"] == null
            ? []
            : List<String>.from(json["ipWhitelist"]!.map((x) => x)),
    createdat:
        json["createdat"] == null ? null : DateTime.parse(json["createdat"]),
    updatedat:
        json["updatedat"] == null ? null : DateTime.parse(json["updatedat"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "organisationId": organisationId,
    "twoFactorEnabled": twoFactorEnabled,
    "enforceTwoFactor": enforceTwoFactor,
    "loginAlerts": loginAlerts,
    "maxLoginAttempts": maxLoginAttempts,
    "requirePinOnDelivery": requirePinOnDelivery,
    "requirePinOnPickup": requirePinOnPickup,
    "ipWhitelist":
        ipWhitelist == null
            ? []
            : List<dynamic>.from(ipWhitelist!.map((x) => x)),
    "createdat": createdat?.toIso8601String(),
    "updatedat": updatedat?.toIso8601String(),
  };
}
