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

class AddCardResponse extends DefaultResponse {
  final String? accessToken;
  final String? accessUrl;
  final String? publickey;
  AddCardResponse({
    super.id,
    required super.message,
    required super.success,
    this.accessToken,
    this.accessUrl,
    this.publickey,
  });
  factory AddCardResponse.fromJson(Map<String, dynamic> json) =>
      AddCardResponse(
        id: json['id'],
        message: json['message'],
        success: json['success'],
        accessToken: json['accessToken'],
        accessUrl: json['accessUrl'],
        publickey: json['publickey'],
      );
}
