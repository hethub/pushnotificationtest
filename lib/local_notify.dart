import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future setMessages(Map messages) async {
  print(messages);
  final SharedPreferences prefs = await _prefs;
  List<String> messagesString = [];
  List<String> allData = (prefs.getStringList('notification') ?? []);
  messagesString = [...allData, json.encode(messages)];
  prefs.setStringList('notification', messagesString);
}

class LocalNotifyprov extends ChangeNotifier {
  List<Map<String, dynamic>> _allNotifications = [];
  List<Map<String, dynamic>> get allNotifications => [..._allNotifications];
  int newNotification = 0;

  Future setMessages(Map<String, dynamic> messages) async {
    print(messages);
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = [];
    List<String> allData = (prefs.getStringList('notification') ?? []);
    messagesString = [...allData, json.encode(messages)];
    prefs.setStringList('notification', messagesString);
    _allNotifications.add(messages);
    newNotification++;
    notifyListeners();
  }

  Future<void> setTotalMessage(int msg) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('totalMessage', msg);
  }

  Future<List<Map<String, dynamic>>> getAllMessage() async {
    int newMsg = 0;
    final SharedPreferences prefs = await _prefs;
    int totalOldMsg = prefs.getInt('totalMessage') ?? 0;
    List<String> messagesString = prefs.getStringList('notification') ?? [];
    List<Map<String, dynamic>> messages = [];

    if (messagesString.isNotEmpty) {
      for (var element in messagesString) {
        messages.add(json.decode(element));
      }
      _allNotifications = messages;
      notifyListeners();
    }
    // Current message length
    int len = messages.length;

    if (len > totalOldMsg) {
      newMsg = len - totalOldMsg;
      // set total message for next time
      setTotalMessage(len);
      newNotification = newMsg;
      notifyListeners();
    }
    // List returnVal = [messages, newMsg];
    // print('========================================= $messages');

    // return [messages, newMsg];
    return messages;
  }
}

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
}
