import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// set message when app is in forground
Future setMessagesInBackground(Map messages) async {
  final SharedPreferences prefs = await _prefs;
  List<String> messagesString = [];
  List<String> allData = (prefs.getStringList('notification') ?? []);
  messagesString = [...allData, json.encode(messages)];

  // prefs.setStringList('notification', messagesString);
  //===================
  List<Map<String, dynamic>> messagesMapList = [];
  for (var element in messagesString) {
    messagesMapList.add(json.decode(element));
  }

  if (messagesMapList.length < 50) {
    prefs.setStringList('notification', messagesString);
  } else {
    List<String> msgString = [];
    for (int i = 10; i < messagesMapList.length; i++) {
      msgString.add(json.encode(messagesMapList[i]));
    }
    prefs.setStringList('notification', msgString);
    prefs.setInt('totalMessage', messagesMapList.length - 11);
  }
  //==================
}

class LocalNotifyprov extends ChangeNotifier {
  List<Map<String, dynamic>> _allNotifications = [];
  int _newNotifications = 0;
  List<Map<String, dynamic>> get allNotifications => [..._allNotifications];
  int get newNotification => _newNotifications;

  // set message when app is in forground
  Future setMessagesInForground(Map<String, dynamic> messages) async {
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

  Future<void> onResumed() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.reload();

    List<String> messagesString = prefs.getStringList('notification') ?? [];
    List<Map<String, dynamic>> messages = [];
    if (messagesString.isNotEmpty) {
      for (var element in messagesString) {
        messages.add(json.decode(element));
      }
    }
    _allNotifications = messages;
    int oldmessage = prefs.getInt('totalMessage') ?? 0;
    int len = _allNotifications.length;
    int badgeCount = 0;
    if (oldmessage < len) {
      badgeCount = len - oldmessage;
      setTotalMessage(len);
    }
    _newNotifications = badgeCount;
    print('resume');
    notifyListeners();
  }

  void clearBadge() async {
    setTotalMessage(allNotifications.length);
    _newNotifications = 0;
    notifyListeners();
  }
}
