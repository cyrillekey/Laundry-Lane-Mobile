import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/notifications/service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tabler_icons/tabler_icons.dart';

class NotificationsView extends StatefulHookConsumerWidget {
  const NotificationsView({super.key});
  static const String routeName = "/Notifications";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NotificationsViewState();
}

class NotificationsViewState extends ConsumerState<NotificationsView> {
  static const List<String> tags = ["All", "Payment", "Booking", "Remainders"];

  @override
  void initState() {
    super.initState();
    showPushNotificationPermissionDialog(context);
  }

  @override
  Widget build(BuildContext context) {
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
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 4),
                  padding: EdgeInsets.only(
                    top: 32,
                  ).copyWith(left: 16, right: 16),
                  itemBuilder:
                      (context, index) => Container(
                        color: Colors.red,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                      ),
                  itemCount: notifications.length,
                );
              },
              error: (_, __) {
                return SizedBox();
              },
              loading: () {
                return CircularProgressIndicator.adaptive();
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showPushNotificationPermissionDialog(BuildContext context) async {
  final isGranted = await Permission.notification.isGranted;
  final isDenied = await Permission.notification.isPermanentlyDenied;
  if (!isGranted && !isDenied) {
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (modalContext) {
          return PushNotificationDialog();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        showDragHandle: true,
        requestFocus: true,
      );
    }
  }
}

class PushNotificationDialog extends StatelessWidget {
  const PushNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 6),
          Text(
            "Turn on notifications ?",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            "Get alerts for laundry orders, payments, offers and status updates",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).hintColor),
          ),
          SizedBox(height: 20),
          Container(height: MediaQuery.of(context).size.height * 0.22),
          TextButton(
            onPressed: () async {
              await Permission.notification.request();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Color.fromRGBO(121, 20, 199, 1),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width * 0.92, 46),
              ),
            ),
            child: Text(
              "Allow Notifications",
              style: GoogleFonts.almarai(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Remind Me Later",
                style: GoogleFonts.almarai(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
