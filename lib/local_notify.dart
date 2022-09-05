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
  int _newNotifications = 0;
  List<Map<String, dynamic>> get allNotifications => [..._allNotifications];
  int get newNotification => _newNotifications;

  Future setMessagesBack(Map messages) async {
    // print(messages);
    final SharedPreferences prefs = await _prefs;
    List<String> messagesString = [];
    List<String> allData = (prefs.getStringList('notification') ?? []);
    messagesString = [...allData, json.encode(messages)];
    prefs.setStringList('notification', messagesString);
    _newNotifications++;

    await getMessage().then(
      (value) {
        _allNotifications = value;
        notifyListeners();
      },
    );
    print(_newNotifications);
    print(_allNotifications.length);
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

    _allNotifications.add(messages);
    _newNotifications++;
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
    await getMessage().then((data) {
      int len = data.length;

      if (oldmessage < len) {
        badgeCount = len - oldmessage;
        setTotalMessage(len);
        notifyListeners();
      }
      _allNotifications = data;
      _newNotifications = badgeCount;

      notifyListeners();
    });

    return badgeCount;
  }

  void clearBadge() async {
    setTotalMessage(allNotifications.length);
    _newNotifications = 0;
    notifyListeners();
  }
}
