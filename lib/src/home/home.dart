import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundrylane/src/home/tabs/home.dart';
import 'package:laundrylane/src/home/tabs/messages.dart';
import 'package:laundrylane/src/home/tabs/orders.dart';
import 'package:laundrylane/src/home/tabs/profile.dart';
import 'package:laundrylane/src/request_order/service_select.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tabler_icons/tabler_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = "/Home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> tabs = [
    HomeTab(),
    OrdersTab(),
    MessagesTab(),
    ProfileScreen(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
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
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        onTap: (p0) {
          setState(() {
            currentIndex = p0;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(TablerIcons.home),
            title: Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: Image.asset("assets/icons/time-table.png", height: 26),
            title: Text("Bookings"),
          ),
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.bell),
            title: Text("Messages"),
          ),
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
