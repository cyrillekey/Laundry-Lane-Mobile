import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});
  static const String routeName = "/security-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Security"), centerTitle: true));
  }
}
