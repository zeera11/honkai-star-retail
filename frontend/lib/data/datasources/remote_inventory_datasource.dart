import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteInventoryDataSource {
  static const String baseUrl = "http://localhost:3000";

  // GET ALL ITEMS
  Future<List<dynamic>> getItems() async {
    final response = await http.get(
      Uri.parse("$baseUrl/items"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load items");
    }
  }

  // ADD ITEM
  Future<void> addItem(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/items"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add item");
    }
  }

  // UPDATE ITEM
  Future<void> updateItem(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/items/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update item");
    }
  }

  // DELETE ITEM
  Future<void> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/items/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete item");
    }
  }
}