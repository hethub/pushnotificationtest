import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class LocalNotification {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  Future<void> setTotalMessage(int msg) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('totalMessage', msg);
  }

  Stream<List> getAllMessage() async* {
    int newMsg = 0;
    final SharedPreferences prefs = await _prefs;
    int totalMsg = prefs.getInt('totalMessage') ?? 0;
    List<String> messagesString = prefs.getStringList('notification') ?? [];
    List<Map<String, dynamic>> messages = [];

    if (messagesString.isNotEmpty) {
      for (var element in messagesString) {
        messages.add(json.decode(element));
      }
    }
    int len = messages.length;

    if (len > totalMsg) {
      newMsg = len - totalMsg;
      setTotalMessage(len);
    }
    // List returnVal = [messages, newMsg];
    // print('========================================= $messages');
    yield [messages, newMsg];
  }

  // Future<List> getAllMessage() async {
  //   int newMsg = 0;
  //   final SharedPreferences prefs = await _prefs;
  //   int totalMsg = prefs.getInt('totalMessage') ?? 0;
  //   List<String> messagesString = prefs.getStringList('notification') ?? [];
  //   List<Map<String, dynamic>> messages = [];

  //   if (messagesString.isNotEmpty) {
  //     for (var element in messagesString) {
  //       messages.add(json.decode(element));
  //     }
  //   }
  //   int len = messages.length;

  //   if (len > totalMsg) {
  //     newMsg = len - totalMsg;
  //     setTotalMessage(len);
  //   }
  //   // List returnVal = [messages, newMsg];
  //   // print('========================================= $messages');
  //   return [messages, newMsg];
  // }
}
