import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/home/tabs/home.dart';
import 'package:laundrylane/src/home/tabs/messages.dart';
import 'package:laundrylane/src/home/tabs/orders.dart';
import 'package:laundrylane/src/home/tabs/profile.dart';
import 'package:laundrylane/src/request_order/service_select.dart';
import 'package:laundrylane/theme/util.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tabler_icons/tabler_icons.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});
  static const String routeName = "/Home";

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      HomeTab(
        onProfileTap: () {
          setState(() {
            currentIndex = 3;
          });
        },
      ),
      OrdersTab(),
      MessagesTab(),
      ProfileScreen(),
    ];
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final themeListener = ref.watch(themeProvider).value;
    return Scaffold(
      floatingActionButton:
          currentIndex == 0
              ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).pushNamed(ServiceSelect.routeName);
                },

                label: Text("New Order", style: GoogleFonts.almarai()),
              )
              : null,
      // backgroundColor: Color.fromRGBO(244, 245, 247, 1),
      body: SafeArea(child: tabs[currentIndex]),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        selectedItemColor:
            themeListener == ThemeMode.dark
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        onTap: (p0) {
          setState(() {
            currentIndex = p0;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(
              TablerIcons.home,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("Home", style: Theme.of(context).textTheme.labelLarge),
          ),
          SalomonBottomBarItem(
            icon: Image.asset(
              "assets/icons/time-table.png",
              height: 26,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "Bookings",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SalomonBottomBarItem(
            icon: Icon(
              CupertinoIcons.bell,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "Messages",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SalomonBottomBarItem(
            icon: Icon(
              CupertinoIcons.profile_circled,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
