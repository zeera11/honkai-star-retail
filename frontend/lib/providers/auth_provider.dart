import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../api/api.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  UserAccount? _currentUser;

  bool _isLoading = false;

  AuthProvider(this._repository) {
    checkPersistentSession();
  }

  UserAccount? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _currentUser != null;

  String get userRole => _currentUser?.role ?? 'user';

  // =========================
  // RESTORE SESSION
  // =========================

  Future<void> checkPersistentSession() async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('saved_email');

    if (email != null) {
      final savedTrailblazerId = prefs.getString('saved_id') ?? 'unknown_user';
      final savedToken = prefs.getString('saved_token');
      if (savedToken != null) {
        Api.token = savedToken;
      }

      _currentUser = UserAccount(
        email: email,
        password: "",
        trailblazerId: savedTrailblazerId,
        phone: prefs.getString('saved_phone') ?? "",
        role: prefs.getString('saved_role') ?? "user",

        // PROFILE NAME DEFAULTS TO USERNAME
        firstName: prefs.getString('saved_first_name') ?? savedTrailblazerId,

        lastName: prefs.getString('saved_last_name') ?? "",
      );

      notifyListeners();
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<String?> login(
    String identifier,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    final user = await _repository.login(
      identifier,
      password,
    );

    _isLoading = false;

    if (user == null) {
      notifyListeners();

      return "Access Denied: Invalid Credentials";
    }

    _currentUser = user;

    // SAVE SESSION
    final prefs = await SharedPreferences.getInstance();

    if (Api.token != null) {
      await prefs.setString('saved_token', Api.token!);
    }

    await prefs.setString(
      'saved_email',
      user.email,
    );

    await prefs.setString(
      'saved_role',
      user.role,
    );

    await prefs.setString(
      'saved_id',
      user.trailblazerId,
    );

    await prefs.setString(
      'saved_phone',
      user.phone,
    );

    await prefs.setString(
      'saved_first_name',
      user.firstName,
    );

    await prefs.setString(
      'saved_last_name',
      user.lastName,
    );

    notifyListeners();

    return null;
  }

  Future<String?> loginWithGoogle({String? email, String? name}) async {
    _isLoading = true;

    notifyListeners();

    final user = await _repository.loginWithGoogle(email: email, name: name);

    _isLoading = false;

    if (user == null) {
      notifyListeners();

      return "Google authentication failed";
    }

    _currentUser = user;

    final prefs = await SharedPreferences.getInstance();

    if (Api.token != null) {
      await prefs.setString('saved_token', Api.token!);
    }

    await prefs.setString(
      'saved_email',
      user.email,
    );

    await prefs.setString(
      'saved_role',
      user.role,
    );

    await prefs.setString(
      'saved_id',
      user.trailblazerId,
    );

    notifyListeners();

    return null;
  }

  // =========================
  // REGISTER
  // =========================

  Future<String?> register({
    required String email,
    required String password,
    required String trailblazerId,
    required String phone,
  }) async {
    _isLoading = true;

    notifyListeners();

    final success = await _repository.register(
      email: email,
      password: password,
      trailblazerId: trailblazerId,
      phone: phone,
    );

    _isLoading = false;

    notifyListeners();

    if (!success) {
      return "Identity error: Email or ID already exists";
    }

    return null;
  }

  // =========================
  // PROFILE UPDATE
  // =========================

  Future<void> updateProfile({
    required String trailblazerId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    if (_currentUser == null) return;

    _currentUser = UserAccount(
      email: email,

      password: _currentUser!.password,

      // UPDATED USERNAME
      trailblazerId: trailblazerId,

      phone: _currentUser!.phone,

      role: _currentUser!.role,

      firstName: firstName,

      lastName: lastName,

      notificationsEnabled: _currentUser!.notificationsEnabled,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'saved_email',
      email,
    );

    await prefs.setString(
      'saved_id',
      trailblazerId,
    );

    await prefs.setString(
      'saved_first_name',
      firstName,
    );

    await prefs.setString(
      'saved_last_name',
      lastName,
    );

    notifyListeners();
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    _currentUser = null;
    Api.token = null;

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    notifyListeners();
  }
}
