import 'package:laundrylane/models/user_model.dart';

class AuthResponse {
  final String? token;
  final String message;
  final int? id;
  final bool success;
  final UserModel? user;

  AuthResponse({
    this.token,
    required this.message,
    this.id,
    required this.success,
    this.user,
  });
  AuthResponse.fromJson(Map<String, dynamic> json)
    : token = json['token'],
      message = json['message'],
      id = json['id'],
      success = json['success'] ?? false,
      user = json['user'] == null ? null : UserModel.fromJson(json['user']);
}
