import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:laundrylane/models/auth_response.dart';
import 'package:laundrylane/models/default_response.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final signupMutation = Mutation<AuthResponse>();
final loginMutation = Mutation<AuthResponse>();

Future<AuthResponse> login(String email, String password) async {
  final response = await apiDio
      .post(
        "/authentication/login",
        data: {"value": email, "password": password},
        options: Options(contentType: "application/json"),
      )
      .then((value) => value.data)
      .catchError((err) {
        return jsonDecode(err?.response.toString() ?? "{}");
      });
  if (response == null) {
    return AuthResponse(
      message: "Error! Could not authenticate user",
      id: 0,
      success: false,
    );
  }
  AuthResponse authResponse = AuthResponse.fromJson(response);
  return authResponse;
}

/// Logs a user in using their email and password.
///
/// This function sends a POST request to `/authentication/login` with the user's email and password.
/// If the request is successful, it returns an [AuthResponse] containing the user's ID and a success message.
/// If the request fails, it returns an [AuthResponse] containing an error message and a failure status.
///
/// The response is expected to be in JSON format.

Future<AuthResponse> signUp(String name, String email, String password) async {
  final response = await apiDio
      .post(
        "/authentication/signup",
        data: {"email": email, "password": password, "name": name},
        options: Options(contentType: "application/json"),
      )
      .then((value) => value.data)
      .catchError((err) {
        return jsonDecode(err?.response.toString() ?? "{}");
      });

  if (response == null) {
    return AuthResponse(
      message: "Error! Could not authenticate user",
      id: 0,
      success: false,
    );
  }

  AuthResponse authResponse = AuthResponse.fromJson(response);
  return authResponse;
}

Future<DefaultResponse> createAddress({
  required LatLng position,
  required String type,
  required String recipientName,
  required String recipientPhone,
  String? houseNo,
  String? landmark,
  String? street,
}) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token") ?? "";
    final response = await apiDio
        .post(
          "/address",
          data: {
            "latitude": position.latitude,
            "longitude": position.longitude,
            "type": type,
            "houseNo": houseNo,
            "recipientName": recipientPhone,
            "recipientPhone": recipientName,
            "landmark": landmark,
            "street": street,
          },
          options: Options(
            contentType: "application/json",
            headers: {"Authorization": "Bearer $token"},
          ),
        )
        .then((resp) => resp.data)
        .catchError((err) => err.response);
    if (response == null) {
      return DefaultResponse(
        success: false,
        message: "Error! Could not create address",
      );
    }
    return DefaultResponse.fromJson((response));
  } catch (e) {
    return DefaultResponse(
      message: "Error! Could not create address",
      success: false,
    );
  }
}

Future<DefaultResponse> updateAddress(
  int id, {
  required LatLng position,
  required String type,
  required String recipientName,
  required String recipientPhone,
  String? houseNo,
  String? landmark,
  String? street,
}) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token") ?? "";
    final response = await apiDio
        .put(
          "/address/$id",
          data: {
            "latitude": position.latitude,
            "longitude": position.longitude,
            "type": type,
            "houseNo": houseNo,
            "recipientName": recipientPhone,
            "recipientPhone": recipientName,
            "landmark": landmark,
            "street": street,
          },
          options: Options(
            contentType: "application/json",
            headers: {"Authorization": "Bearer $token"},
          ),
        )
        .then((resp) => resp.data)
        .catchError((err) => err.response);
    if (response == null) {
      return DefaultResponse(
        success: false,
        message: "Error! Could not create address",
      );
    }
    return DefaultResponse.fromJson((response));
  } catch (e) {
    return DefaultResponse(
      message: "Error! Could not create address",
      success: false,
    );
  }
}

Future<DefaultResponse> requestPasswordReset(String email) async {
  try {
    final response = await apiDio
        .post(
          "/authentication/resetPassword",
          data: {"email": email},
          options: Options(contentType: "application/json"),
        )
        .then((value) => value.data)
        .catchError((err) {
          return jsonDecode(err?.response.toString() ?? "{}");
        });
    if (response == null) {
      return DefaultResponse(
        success: false,
        message: "Error! Could not request password reset",
      );
    }
    return DefaultResponse.fromJson((response));
  } catch (e) {
    return DefaultResponse(
      message: "Error! Could not reset password",
      success: false,
    );
  }
}

Future<DefaultResponse> verifyOTP(String email, String otp) async {
  try {
    final response = await apiDio
        .post(
          "/authentication/resetpassword/validate-otp",
          data: {"email": email, "otp": otp},
          options: Options(contentType: "application/json"),
        )
        .then((value) => value.data)
        .catchError((err) {
          return jsonDecode(err?.response.toString() ?? "{}");
        });
    if (response == null) {
      return DefaultResponse(
        success: false,
        message: "Error! Could not verify otp",
      );
    }
    return DefaultResponse.fromJson((response));
  } catch (e) {
    return DefaultResponse(
      message: "Error! Could not verify otp",
      success: false,
    );
  }
}

Future<AuthResponse> updatePassword(
  String token,
  String password,
  String confirmPassword,
) async {
  try {
    final response = await apiDio
        .put(
          "/authentication/resetpassword/update-password",
          data: {"password": password, "confirmPassword": confirmPassword},
          options: Options(headers: {"Authorization": "Bearer $token"}),
        )
        .then((value) => value.data)
        .catchError((err) {
          return jsonDecode(err?.response.toString() ?? "{}");
        });
    if (response == null) {
      return AuthResponse(
        message: "Error! Could not update password",
        id: 0,
        success: false,
      );
    }
    return AuthResponse.fromJson((response));
  } catch (e) {
    return AuthResponse(
      message: "Error! Could not update password",
      id: 0,
      success: false,
    );
  }
}

Future<AuthResponse> socialLogin(String token) async {
  try {
    final response = await apiDio.post(
      "/authentication/social-auth",
      data: {"token": token},
    );
    if (response.data == null) {
      return AuthResponse(
        message: "Error! Could not login",
        id: 0,
        success: false,
      );
    }
    return AuthResponse.fromJson((response.data));
  } catch (e) {
    return AuthResponse(
      message: "Error! Could not authenticate user",
      success: false,
    );
  }
}

Future<AuthResponse> updateUser({
  String? name,
  required String email,
  String? phone,
  String? username,
  String? avatar,
  DateTime? dateOfBirth,
  String? gender,
}) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token") ?? "";

    final response = await apiDio
        .put(
          "/user",
          data: {
            "name": name,
            "email": email,
            "phone": phone,
            "username": username,
            "avatar": avatar,
            "gender": gender,
            "dateOfBirth": dateOfBirth?.toUtc().toIso8601String(),
          },
          options: Options(headers: {"Authorization": "Bearer $token"}),
        )
        .then((value) => value.data)
        .catchError((err) {
          return jsonDecode(err?.response.toString() ?? "{}");
        });

    if (response == null) {
      return AuthResponse(
        success: false,
        message: "Error! Could not update user",
      );
    }
    return AuthResponse.fromJson((response));
  } catch (e) {
    return AuthResponse(
      success: false,
      message: "Error! Could not update user",
    );
  }
}

Future<DefaultResponse> addUserCard({
  required String cardNumber,
  required String cvv,
  required String expiry,
  required String holderName,
  required bool isDefault,
}) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token") ?? "";
    final response = await apiDio
        .post(
          "/payments/card",
          data: {
            "cardNumber": cardNumber,
            "expiryDate": expiry,
            "cvv": cvv,
            "isDefault": isDefault,
            "name": holderName,
          },
          options: Options(headers: {"Authorization": "Bearer $token"}),
        )
        .then((resp) => resp.data)
        .catchError((err) {
          return jsonDecode(err?.response.toString() ?? "{}");
        });
    print(response);
    if (response == null) {
      return DefaultResponse(
        success: false,
        message: "Error! Could not add card",
      );
    }
    return DefaultResponse.fromJson((response));
  } catch (e) {
    print(e);
    return DefaultResponse(
      success: false,
      message: "Error! Could not add card",
    );
  }
}
