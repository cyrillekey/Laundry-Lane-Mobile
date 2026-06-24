import 'package:collection/collection.dart';
import 'package:laundrylane/models/chat_message.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension ListExtensions on List<ChatMessage> {
  List<ChatMessage> addIfNotExist(ChatMessage message) {
    bool exists = firstWhereOrNull((e) => e.id == message.id) != null;
    if (!exists) {
      add(message);
    }
    return this;
  }
}
