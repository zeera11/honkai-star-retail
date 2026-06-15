class UserAccount {
  final String email;
  final String password;

  // MAIN USERNAME / PUBLIC IDENTITY
  final String trailblazerId;

  final String phone;
  final String role; // admin / user

  // OPTIONAL PROFILE DATA
  String firstName;
  String lastName;

  bool notificationsEnabled;

  UserAccount({
    required this.email,
    required this.password,
    required this.trailblazerId,
    required this.phone,
    this.role = 'user',

    // DEFAULT PROFILE NAME FOLLOW USERNAME
    String? firstName,
    this.lastName = "",
    this.notificationsEnabled = true,
  }) : firstName = firstName ?? trailblazerId;

  Map<String, String> toMap() {
    return {
      'email': email,
      'trailblazerId': trailblazerId,
      'phone': phone,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
