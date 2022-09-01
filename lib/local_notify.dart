import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class LocalNotification {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Future<void> storeNotification(List<String> data) async {
  //   final SharedPreferences prefs = await _prefs;

  //   List<String> allData = (prefs.getStringList('notifications') ?? []);
  //   if (allData.isEmpty) {
  //     prefs.setStringList('notifications', [...data, '']);
  //   }
  // }

  // Future<List<String>> getAllvalue() async {
  //   final SharedPreferences prefs = await _prefs;
  //   List<String> value = (prefs.getStringList('notifications') ?? []);
  //   // print(value);
  //   return value;
  // }

  Future setMessages(Map messages) async {
    print(messages);
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = [];
    List<String> allData = (prefs.getStringList('notification') ?? []);
    messagesString = [...allData, json.encode(messages)];
    prefs.setStringList('notification', messagesString);
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = prefs.getStringList('notification') ?? [];
    // print(messagesString.runtimeType);
    List<Map<String, dynamic>> messages = [];
    if (messagesString.isNotEmpty) {
      for (var element in messagesString) {
        messages.add(json.decode(element));
      }
    }
    return messages;
  }
}
