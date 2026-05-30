import 'package:laundrylane/models/clothing_type.dart';
import 'package:laundrylane/models/delivery_zone.dart';
import 'package:laundrylane/models/order_model.dart';

class FullOrderDetails {
  final Order? order;
  final DeliveryZone? deliveryZone;
  final List<Statuses>? statuses;
  final List<OrderItem>? items;

  FullOrderDetails({this.order, this.deliveryZone, this.statuses, this.items});
  factory FullOrderDetails.fromJson(Map<String, dynamic> json) {
    return FullOrderDetails(
      order: Order.fromJson(json),
      deliveryZone:
          json['deliveryZone'] != null
              ? DeliveryZone.fromJson(json['deliveryZone'])
              : null,
      statuses:
          json['statuses'] != null
              ? List<Statuses>.from(
                json['statuses'].map((x) => Statuses.fromJson(x)),
              )
              : null,
      items:
          json['items'] != null
              ? List<OrderItem>.from(
                json['items'].map((x) => OrderItem.fromJson(x)),
              )
              : null,
    );
  }
}

class Statuses {
  final int id;
  final int orderId;
  final Orderstatus status;
  final DateTime createdat;
  final DateTime updatedat;

  Statuses({
    required this.id,
    required this.orderId,
    required this.status,
    required this.createdat,
    required this.updatedat,
  });

  factory Statuses.fromJson(Map<String, dynamic> json) {
    return Statuses(
      id: json['id'],
      orderId: json['orderId'],
      status: Orderstatus.values.firstWhere(
        (element) => element.name == json['status'],
      ),
      createdat: DateTime.parse(json['createdat']),
      updatedat: DateTime.parse(json['updatedat']),
    );
  }
}

enum Orderstatus {
  pending("PENDING"),
  inProgress("IN_PROGRESS"),
  completed("COMPLETED"),
  outForDelivery("OUT_FOR_DELIVERY"),
  readyForPickup("READY_FOR_PICKUP"),
  readyForDelivery("READY_FOR_DELIVERY"),
  cancelled("CANCELLED");

  const Orderstatus(this.name);
  final String name;

  // from string to enum
  static Orderstatus fromString(String status) {
    return Orderstatus.values.firstWhere((element) => element.name == status);
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final ClothingType? product;
  final num price;
  final DateTime createdat;
  final DateTime updatedat;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    this.product,
    required this.price,
    required this.createdat,
    required this.updatedat,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      quantity: json['quantity'],
      product:
          json['product'] == null
              ? null
              : ClothingType.fromJson(json['product']),
      price: json['price'],
      createdat: DateTime.parse(json['createdat']),
      updatedat: DateTime.parse(json['updatedat']),
    );
  }
}
