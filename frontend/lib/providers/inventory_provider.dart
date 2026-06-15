import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../data/repositories/inventory_repository.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryRepository _repository;
  List<Item> _items = [];
  bool _isLoading = false;

  InventoryProvider(this._repository) {
    loadMainItems(); // Memuat data main items saat provider dibuat
  }

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    _items = await _repository.getItems();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMainItems() async {
    _isLoading = true;
    notifyListeners();

    _items = await _repository.getMainItems();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Item>> loadEventItems(
    String eventTag,
  ) async {
    return await _repository.getEventItems(
      eventTag,
    );
  }

  Future<void> addItem(Item item) async {
    await _repository.addItem(item);
    await loadMainItems(); // Refresh state
  }

  Future<void> updateItem(Item updatedItem) async {
    await _repository.updateItem(updatedItem);
    await loadMainItems(); // Refresh state
  }

  Future<void> deleteItem(int id) async {
    await _repository.deleteItem(id);
    await loadMainItems(); // Refresh state
  }

  Future<void> reduceStock(int itemId, int quantity) async {
    await _repository.reduceStock(itemId, quantity);
    await loadMainItems(); // Refresh state
  }
}
