import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/src/login/login.dart';
import 'package:laundrylane/src/payments/payment_methods.dart';
import 'package:laundrylane/theme/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabler_icons/tabler_icons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeProvider).value;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12).copyWith(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Center(child: CircleAvatar(minRadius: 50)),
          SizedBox(height: 12),
          Center(
            child: Text(
              "John Doe",
              style: GoogleFonts.almarai(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 2),
          Center(
            child: Text(
              "johndoe@mailsac.com",
              style: GoogleFonts.almarai(
                color: Color.fromRGBO(158, 150, 150, 1),
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 24),
          Card(
            color:
                theme == ThemeMode.light
                    ? Colors.white
                    : Theme.of(context).cardTheme.color,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SettingItem(
                    label: "Profile Details",
                    icon: TablerIcons.user_circle,
                  ),
                  Divider(),
                  SettingItem(
                    label: "Login and security",
                    icon: TablerIcons.lock_access,
                  ),
                  Divider(),
                  SettingItem(label: "Notification", icon: TablerIcons.bell),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            color:
                theme == ThemeMode.light
                    ? Colors.white
                    : Theme.of(context).cardTheme.color,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SettingItem(label: "Password", icon: TablerIcons.lock),
                  Divider(),
                  SettingItem(
                    label: "Payment Methods",
                    icon: TablerIcons.credit_card,
                    onClick:
                        () => Navigator.of(
                          context,
                        ).pushNamed(PaymentMethods.routeName),
                  ),
                  Divider(),
                  SettingItem(label: "Addresses", icon: TablerIcons.map_2),
                  Divider(),
                  ThemeSwitch(),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            color:
                theme == ThemeMode.light
                    ? Colors.white
                    : Theme.of(context).cardTheme.color,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SettingItem(label: "Support", icon: TablerIcons.help),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            color:
                theme == ThemeMode.light
                    ? Colors.white
                    : Theme.of(context).cardTheme.color,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SettingItem(
                    label: "Logout",
                    iconColor: Colors.red,
                    icon: TablerIcons.logout,
                    onClick: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog.adaptive(
                              title: Text("Logout"),
                              content: Text("Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    await preferences.remove("userId");
                                    await preferences.remove("token");
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      LoginPage.routeName,
                                      (route) => route.isFirst,
                                    );
                                  },
                                  child: Text("Logout"),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    this.onClick,
    required this.label,
    required this.icon,
    this.iconColor,
  });
  final void Function()? onClick;
  final String label;
  final Color? iconColor;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: iconColor),
            SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.almarai(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Icon(TablerIcons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final watchTheme = ref.watch(themeProvider).value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(TablerIcons.moon, size: 20),
          SizedBox(width: 12),
          Text(
            "Switch theme",
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          Spacer(),
          SizedBox(
            height: 16,
            child: Switch.adaptive(
              value: watchTheme == ThemeMode.dark,
              onChanged: (value) async {
                (await SharedPreferences.getInstance()).setBool(
                  "isDark",
                  watchTheme == ThemeMode.dark ? false : true,
                );

                ref.invalidate(themeProvider);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              thumbIcon: WidgetStatePropertyAll(Icon(TablerIcons.bulb)),
            ),
          ),
        ],
      ),
    );
  }
}
