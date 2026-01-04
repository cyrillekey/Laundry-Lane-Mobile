import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({
    super.key,
    this.builder,
    this.style,
    this.label,
    this.child,
    this.textStyle,
    required this.onPress,
  });
  final Widget Function(bool isLoading)? builder;
  final ButtonStyle? style;
  final Widget? child;
  final String? label;
  final FutureOr Function() onPress;
  final TextStyle? textStyle;

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(isLoading);
    }
    return TextButton(
      onPressed: () async {
        try {
          setState(() {
            isLoading = true;
          });
          await widget.onPress();
          setState(() {
            isLoading = false;
          });
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      style:
          widget.style ??
          ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromRGBO(45, 111, 241, 1),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width, 44),
            ),
          ),
      child:
          isLoading
              ? CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.white,
              )
              : widget.child ??
                  Text(
                    widget.label ?? "Submit",
                    style: widget.textStyle ?? GoogleFonts.almarai(),
                  ),
    );
  }
}
