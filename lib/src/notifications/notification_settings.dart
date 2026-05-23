import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NotificationSettings extends StatefulWidget {
  static const routeName = "/notification-settings";
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Settings"), centerTitle: true),
      body: FormBuilder(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                "Notifications",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Configure the type on notifications you wish to receive through push notifications. You can turn them off at any time.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              SizedBox(height: 40),
              NotificationItem(
                title: "New Order",
                name: "newOrder",
                description:
                    "Receive a notification when a new order is placed",
              ),
              SizedBox(height: 12),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.title,
    required this.description,
    required this.name,
  });
  final String title;
  final String description;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
        Spacer(),
        FormBuilderField<bool>(
          builder:
              (fieldProp) => Switch.adaptive(
                value: fieldProp.value ?? false,
                onChanged: (value) => fieldProp.didChange(value),
              ),
          name: name,
        ),
      ],
    );
  }
}
