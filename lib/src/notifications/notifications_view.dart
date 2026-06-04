import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:laundrylane/models/notification_model.dart';
import 'package:laundrylane/src/notifications/notification_settings.dart';
import 'package:laundrylane/src/notifications/service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
            onPressed: () {
              Navigator.of(context).pushNamed(NotificationSettings.routeName);
            },
            icon: Icon(TablerIcons.settings_2, size: 24),
          ),
        ],
      ),
      body: notifications.when(
        data: (notifications) {
          return RefreshIndicator.adaptive(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async => ref.invalidate(notificationsState),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 20),
              padding: EdgeInsets.only(top: 8).copyWith(left: 16, right: 16),
              itemBuilder:
                  (context, index) =>
                      NotificationItem(notification: notifications[index]),
              itemCount: notifications.length,
            ),
          );
        },
        error: (_, __) {
          return SizedBox();
        },
        loading: () {
          return Center(child: CircularProgressIndicator.adaptive());
        },
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

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notification});
  final AppNotification notification;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).colorScheme.surface,
      splashColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // TODO implement order ridirect by type
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              // color: Color.fromRGBO(246, 246, 246, 1),
              color: Theme.of(context).splashColor,
              borderRadius: BorderRadius.circular(46),
            ),
            child: Icon(TablerIcons.bell, size: 26),
          ),
          SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color.fromRGBO(112, 112, 112, 1),
                  ),
                ),
              ),

              SizedBox(height: 8),
              Text(
                Jiffy.parse(
                  notification.createdat,
                ).format(pattern: "dd, MMM, HH:mm a"),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Color.fromRGBO(112, 112, 112, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
