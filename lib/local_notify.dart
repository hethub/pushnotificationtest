import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// Future setMessages(Map messages) async {
//   // print(messages);
//   final SharedPreferences prefs = await _prefs;
//   List<String> messagesString = [];
//   List<String> allData = (prefs.getStringList('notification') ?? []);
//   messagesString = [...allData, json.encode(messages)];

//   prefs.setStringList('notification', messagesString);
// }

class LocalNotifyprov extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Map<String, dynamic>> _allNotifications = [];
  int _newNotification = 0;
  List<Map<String, dynamic>> get allNotifications => [..._allNotifications];
  int get newNotification => _newNotification;

  Future setMessagesBack(Map messages) async {
    // print(messages);
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = [];
    List<String> allData = (prefs.getStringList('notification') ?? []);
    messagesString = [...allData, json.encode(messages)];
    prefs.setStringList('notification', messagesString);
    notifyListeners();
  }

  // set message when app is in forground
  Future setMessagesForGnd(Map<String, dynamic> messages) async {
    print('============provider ====$messages');
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = [];
    List<String> allData = (prefs.getStringList('notification') ?? []);
    messagesString = [...allData, json.encode(messages)];
    prefs.setStringList('notification', messagesString);
    int newmessage = prefs.getInt('totalMessage') ?? 0;
    prefs.setInt('totalMessage', newmessage++);
    // prefs.setInt('totalMessage', _allNotifications.length + 1);

    _allNotifications.add(messages);
    _newNotification++;
    notifyListeners();
  }

  Future<void> setTotalMessage(int msg) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('totalMessage', msg);
  }

  Future<List<Map<String, dynamic>>> getMessage() async {
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = prefs.getStringList('notification') ?? [];
    List<Map<String, dynamic>> messages = [];
    if (messagesString.isNotEmpty) {
      for (var element in messagesString) {
        messages.add(json.decode(element));
      }
    }

    return messages;
  }

  Future<int> badge() async {
    int badgeCount = 0;
    final SharedPreferences prefs = await _prefs;
    int oldmessage = prefs.getInt('totalMessage') ?? 0;
    // print(oldmessage);

    await getMessage().then((data) {
      int len = data.length;
      if (oldmessage < len) {
        badgeCount = len - oldmessage;
        notifyListeners();
      }
      _allNotifications = data;
      _newNotification = badgeCount;
      //=============
      // prefs.setInt('totalMessage', len);
      print(len);
      notifyListeners();
    });

    return badgeCount;
  }

  void clearBadge() {
    _newNotification = 0;
    notifyListeners();
  }
}
