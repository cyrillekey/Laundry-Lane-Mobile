class AuthResponse {
  final String? token;
  final String message;
  final int? id;
  final bool success;

  AuthResponse({
    this.token,
    required this.message,
    this.id,
    required this.success,
  });
  AuthResponse.fromJson(Map<String, dynamic> json)
    : token = json['token'],
      message = json['message'],
      id = json['id'],
      success = json['success'] ?? false;
}
