import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  const ProgressWidget({super.key, required this.builder});
  final Widget Function(bool isLoading, Function toggleLoading) builder;
  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      isLoading,
      () => setState(() => isLoading = !isLoading),
    );
  }
}
