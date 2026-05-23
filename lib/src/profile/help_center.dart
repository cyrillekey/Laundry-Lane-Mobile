import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});
  static const routeName = '/help-center';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Support Center"), centerTitle: true),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 36),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(145, 73, 234, 1),
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Icon(
                  TablerIcons.message_dots,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Get Support",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
