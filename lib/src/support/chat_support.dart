import 'package:flutter/material.dart';

class ChatSupportPage extends StatelessWidget {
  const ChatSupportPage({super.key});
  static const routeName = '/support-chat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Support"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_rounded)),
        ],
      ),
    );
  }
}
