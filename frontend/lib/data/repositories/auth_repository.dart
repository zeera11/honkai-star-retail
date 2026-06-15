import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user_model.dart';
import '../../api/api.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'mock-client-id.apps.googleusercontent.com',
    scopes: [
      'email',
    ],
  );

  // =========================
  // NORMAL LOGIN
  // =========================

  Future<UserAccount?> login(
    String identifier,
    String password,
  ) async {
    try {
      final res = await Api.login({
        "email": identifier,
        "password": password,
      });

      if (res != null && res['token'] != null) {
        Api.token = res['token'];
        final userData = res['user'];
        return UserAccount(
          email: userData['email'] ?? identifier,
          password: password,
          trailblazerId: userData['name'] ?? "",
          phone: "",
          role: userData['role'] ?? "user",
          firstName: userData['name'] ?? "",
        );
      }
      return null;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }

  // =========================
  // GOOGLE LOGIN
  // =========================

  Future<UserAccount?> loginWithGoogle({String? email, String? name}) async {
    try {
      String finalEmail;
      String finalName;

      if (email != null && name != null) {
        finalEmail = email;
        finalName = name;
      } else {
        GoogleSignInAccount? googleUser;
        try {
          googleUser = await _googleSignIn.signIn();
        } catch (e) {
          print("Real Google Sign-In not configured/available: $e");
        }

        if (googleUser != null) {
          finalEmail = googleUser.email;
          finalName = googleUser.displayName ?? googleUser.email.split('@')[0];
        } else {
          // Fallback mock google user for ease of testing on local Chrome without client ID
          finalEmail = "google_trailblazer@gmail.com";
          finalName = "Google Trailblazer";
        }
      }

      // Call backend Google Login API
      final res = await Api.googleLogin({
        "email": finalEmail,
        "name": finalName,
      });

      if (res != null && res['token'] != null) {
        Api.token = res['token'];
        final userData = res['user'];
        return UserAccount(
          email: userData['email'] ?? email,
          password: "",
          trailblazerId: userData['name'] ?? name,
          phone: "google_account",
          role: userData['role'] ?? "user",
          firstName: userData['name'] ?? name,
        );
      }
      return null;
    } catch (e) {
      print("GOOGLE LOGIN ERROR: $e");
      return null;
    }
  }

  // =========================
  // REGISTER
  // =========================

  Future<bool> register({
    required String email,
    required String password,
    required String trailblazerId,
    required String phone,
  }) async {
    try {
      final res = await Api.register({
        "name": trailblazerId,
        "email": email,
        "password": password,
        "role": "user"
      });
      return res != null && res['message'] == "User registered";
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }
}
