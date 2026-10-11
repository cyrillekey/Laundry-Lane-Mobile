import 'dart:async';

import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton({
    super.key,
    this.builder,
    this.style,
    this.label,
    this.child,
    this.textStyle,
    this.onPress,
    this.size,
    this.disabled = false,
    this.borderRadius,
    this.backgroundColor,
  });
  final Widget Function(bool isLoading, Function(bool state) setLoadingState)?
  builder;
  final ButtonStyle? style;
  final Widget? child;
  final Color? backgroundColor;
  final String? label;
  final Size? size;
  final bool disabled;
  final FutureOr Function()? onPress;
  final TextStyle? textStyle;
  final double? borderRadius;

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(
        isLoading,
        (state) => {
          setState(() {
            isLoading = state;
          }),
        },
      );
    }
    return TextButton(
      onPressed:
          isLoading
              ? null
              : () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  if (widget.onPress != null) {
                    await widget.onPress!();
                  }
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
              widget.disabled == true
                  ? Theme.of(context).unselectedWidgetColor
                  : widget.backgroundColor ??
                      Theme.of(context).colorScheme.primary,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
              ),
            ),
            fixedSize: WidgetStatePropertyAll(
              widget.size ?? Size(MediaQuery.of(context).size.width, 50),
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
                    style:
                        widget.textStyle ??
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              widget.disabled
                                  ? Colors.black
                                  : Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
    );
  }
}
