import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/theme/util.dart';

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
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => AddressCard(),
                separatorBuilder: (context, index) => SizedBox(height: 6),
                itemCount: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends ConsumerWidget {
  const AddressCard({super.key});

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
          children: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
