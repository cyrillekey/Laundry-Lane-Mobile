import 'package:flutter/material.dart';
import 'package:laundrylane/models/catalog_model.dart';
import 'package:laundrylane/models/service_model.dart';

class CheckoutModel {
  final Catalog catalog;
  final String orderType;
  final DateTime pickupDate;
  final TimeOfDay pickupTime;
  final String? deliveryWindow;
  final String washingPreference;
  final ServiceType serviceType;

  CheckoutModel({
    required this.catalog,
    required this.orderType,
    required this.pickupDate,
    required this.pickupTime,

    this.deliveryWindow,
    required this.washingPreference,
    required this.serviceType,
  });
}
