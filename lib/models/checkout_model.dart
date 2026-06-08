import 'package:flutter/material.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/service_model.dart';

class CheckoutModel {
  final Catalog catalog;
  final OrderType orderType;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;
  final String? deliveryWindow;
  final num? weight;
  final String washingPreference;
  final ServiceType? serviceType;
  final String? paymentMethod;

  CheckoutModel({
    required this.catalog,
    required this.orderType,
    this.pickupDate,
    this.pickupTime,
    this.deliveryWindow,
    required this.washingPreference,
    this.serviceType,
    this.weight,
    this.paymentMethod,
  });
  Map<String, dynamic> toJson() => {
    "catalog": catalog.toJson(),
    "orderType": orderType.value,
    "pickupDate": pickupDate?.toIso8601String(),
    "pickupTime": pickupTime?.toString(),
    "deliveryWindow": deliveryWindow,
    "washingPreference": washingPreference,
    "serviceType": serviceType?.toJson(),
    "weight": weight,
    "paymentMethod": paymentMethod,
  };
}

enum OrderType {
  pickup("PICKUP"),
  delivery("DELIVERY"),
  pickupAndDelivery("PICKUP_AND_DELIVERY"); // ← semicolon here

  const OrderType(this.value); // ← const constructor
  final String value; // ← field
}
