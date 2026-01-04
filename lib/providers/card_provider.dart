import 'dart:collection';

import 'package:flutter/material.dart';

class CartItem {
  final int productId;
  int quantity;
  final String type;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.type,
  });
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void editItem(int id, int quantity) {
    int index = _items.indexWhere((e) => e.productId == id);
    CartItem item = _items[index];
    item.quantity = quantity;
    _items[index] = (item);
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((e) => e.productId == id);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
