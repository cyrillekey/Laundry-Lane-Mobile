import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/notifications/service.dart';
import 'package:tabler_icons/tabler_icons.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});
  static const String routeName = "/Notifications";
  static const List<String> tags = ["All", "Payment", "Booking", "Remainders"];
  @override
  Widget build(BuildContext context, ref) {
    final notifications = ref.watch(notificationsState);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(TablerIcons.settings_2, size: 24),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.78,
            child: notifications.when(
              data: (notifications) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: 32),
                  itemBuilder:
                      (context, index) =>
                          Container(color: Colors.red, height: 60),
                  itemCount: notifications.length,
                );
              },
              error: (_, __) {
                return SizedBox();
              },
              loading: () {
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
