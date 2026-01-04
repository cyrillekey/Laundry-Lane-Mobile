class DefaultResponse {
  final String message;
  final bool success;
  final int? id;

  DefaultResponse({required this.message, required this.success, this.id});

  DefaultResponse.fromJson(Map<String, dynamic> json)
    : message = json['message'],
      success = json['success'],
      id = json['id'];
}
