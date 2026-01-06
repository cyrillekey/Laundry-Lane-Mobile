import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tokenProvider = FutureProvider<String>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  return token;
});

final userProvider = FutureProvider<UserModel>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? user = prefs.getString('user');
  if (user == null) {
    return UserModel();
  }
  return UserModel.fromJson(jsonDecode(user));
});
