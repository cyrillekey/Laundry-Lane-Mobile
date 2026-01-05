import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/providers/card_provider.dart';
import 'package:laundrylane/src/app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: ProviderScope(child: MyApp(sharedPreferences: sharedPreferences)),
    ),
  );
}
