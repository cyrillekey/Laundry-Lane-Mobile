import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/home_address.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/theme/util.dart';
import 'package:tabler_icons/tabler_icons.dart';

class AddressList extends StatelessWidget {
  const AddressList({super.key});
  static const String routeName = '/address-list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Addresses"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                fixedSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width, 48),
                ),
                textStyle: WidgetStateProperty.all(
                  Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                iconColor: WidgetStateProperty.all(Colors.white),
                iconSize: WidgetStateProperty.all(28),
              ),
              onPressed: () {},
              label: Text(
                "Add New Address",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              icon: Icon(Icons.add),
            ),
            SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final watchAddress = ref.watch(addressState);
                return watchAddress.when(
                  data: (address) {
                    if (address == null) {
                      // TODO: show no address found
                      return Container();
                    }
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder:
                            (context, index) => AddressCard(address: address),
                        separatorBuilder:
                            (context, index) => SizedBox(height: 6),
                        itemCount: 1,
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends ConsumerWidget {
  const AddressCard({super.key, required this.address});
  final HomeAddress address;

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider).value;
    final bool isDark = theme == ThemeMode.dark;
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 1.5,
          color:
              isDark
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.building,
                  size: 30,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 12),
                Text(
                  "${address.type}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor,
                  ),
                ),
                Spacer(),
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    visualDensity: VisualDensity.compact.copyWith(
                      horizontal:
                          VisualDensity.minimumDensity > -4
                              ? -4
                              : VisualDensity.minimumDensity,
                    ),
                    value: false,
                    onChanged: (value) {},
                    side: WidgetStateBorderSide.resolveWith(
                      (states) => BorderSide(
                        width: 1.5,
                        color:
                            isDark
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).primaryColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "${address.street}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color:
                    isDark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor,
              ),
            ),
            Text(
              "Country",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color:
                    isDark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor,
              ),
            ),
            Text(
              "12212",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color:
                    isDark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor,
              ),
            ),
            Text(
              "${address.recipientPhone}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color:
                    isDark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "View on Map",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color:
                        isDark
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor,
                  ),
                ),
                Spacer(),
                Icon(Icons.more_horiz),
                SizedBox(width: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
