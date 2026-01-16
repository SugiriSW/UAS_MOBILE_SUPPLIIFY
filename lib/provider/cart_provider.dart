import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void increase(int productId) {
    _items[productId]!.quantity++;
    notifyListeners();
  }

  void decrease(int productId) {
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  double get total =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
}
