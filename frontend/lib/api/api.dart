import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://localhost:3000";
  static String? token;

  static Map<String, String> getHeaders({bool json = true}) {
    final Map<String, String> headers = {};
    if (json) {
      headers["Content-Type"] = "application/json";
    }
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  //ITEMS

  static Future getItems() async {
    final res = await http.get(
      Uri.parse("$baseUrl/items"),
      headers: getHeaders(json: false),
    );
    return jsonDecode(res.body);
  }

  static Future createItem(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/items"),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future updateItem(int id, Map data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/items/$id"),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future deleteItem(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/items/$id"),
      headers: getHeaders(json: false),
    );
    return jsonDecode(res.body);
  }

  //AUTH

  static Future login(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future register(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future googleLogin(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/google-login"),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  //CART

  static Future getCart() async {
    final res = await http.get(
      Uri.parse("$baseUrl/cart"),
      headers: getHeaders(json: false),
    );
    return jsonDecode(res.body);
  }

  static Future addToCart(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/cart/add"), // Note: backend uses router.post("/add", ...) so it maps to /cart/add
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  static Future removeFromCart(int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/cart/$id"),
      headers: getHeaders(json: false),
    );
    return jsonDecode(res.body);
  }

  //PAYMENTS

  static Future getPayments() async {
    final res = await http.get(
      Uri.parse("$baseUrl/payments"),
      headers: getHeaders(json: false),
    );
    return jsonDecode(res.body);
  }

  static Future createPayment(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/payments"),
      headers: getHeaders(),
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }
}