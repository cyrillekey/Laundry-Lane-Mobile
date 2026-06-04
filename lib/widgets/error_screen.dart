import 'package:flutter/material.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.details});
  final FlutterErrorDetails details;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("assets/images/laundry_error.png"),
            SizedBox(height: 12),
            Text(
              "Opps! Something went wrong!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 12),
            Text(
              "We encountered an error in the application. Do not worry it is not your fault. The error has been logged and will be fixed soon.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            ProgressButton(
              label: "Report Error",
              onPress:
                  () => Sentry.captureException(
                    details.exception,
                    stackTrace: details.stack,
                    hint: Hint.withMap({"name": details.context?.name}),
                  ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
