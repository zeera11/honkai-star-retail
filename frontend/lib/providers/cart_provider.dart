import 'package:flutter/material.dart';
import 'dart:math';
import '../models/item_model.dart';

class CartItem {
  final Item item;
  int qty;

  CartItem({required this.item, required this.qty});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cart = [];

  // Payment State
  String selectedPayment = 'qris';
  String? orderId;
  DateTime? qrExpiry;
  String? vaNumber;

  List<CartItem> get cart => _cart;

  void addToCart(Item item, int quantity) {
    int index = _cart.indexWhere((c) => c.item.id == item.id);
    if (index != -1) {
      int newQty = _cart[index].qty + quantity;
      _cart[index].qty = newQty > item.stock ? item.stock : newQty;
    } else {
      _cart.add(CartItem(item: item, qty: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(int itemId, int delta) {
    int index = _cart.indexWhere((c) => c.item.id == itemId);
    if (index != -1) {
      int newQty = _cart[index].qty + delta;
      if (newQty >= 1 && newQty <= _cart[index].item.stock) {
        _cart[index].qty = newQty;
        notifyListeners();
      }
    }
  }

  void removeItem(int itemId) {
    _cart.removeWhere((c) => c.item.id == itemId);
    notifyListeners();
  }

  void setPayment(String type) {
    selectedPayment = type;
    notifyListeners();
  }

  void prepareOrder() {
    // Generate Order ID: HSR-XXXX
    orderId = "HSR-${Random().nextInt(9000) + 1000}";

    if (selectedPayment == 'qris') {
      // Expiry 15 minutes from now
      qrExpiry = DateTime.now().add(const Duration(minutes: 15));
    } else {
      // Generate VA: 126 XXXXXXX
      vaNumber = "126 ${Random().nextInt(9000000) + 1000000}";
    }
    notifyListeners();
  }

  int get cartCount => _cart.fold(0, (sum, c) => sum + c.qty);
  int get totalPrice => _cart.fold(0, (sum, c) => sum + (c.item.price * c.qty));

  void clearCart() {
    _cart.clear();
    orderId = null;
    qrExpiry = null;
    vaNumber = null;
    notifyListeners();
  }
}
