import 'dart:convert';

class User {
  String id;
  String password;
  String email;
  String role;
  String profileImageUrl;

  User(this.id, this.password, this.email, this.role, this.profileImageUrl);

  factory User.fromJson(dynamic json) {
    var decodedJson = jsonDecode(json);

    return User(
        decodedJson['id'] as String,
        decodedJson['password'] as String,
        decodedJson['email'] as String,
        decodedJson['role'] as String,
        decodedJson['profileImageUrl'] as String
    );
  }
}