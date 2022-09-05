import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_sns/local_notify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './list_of_notification.dart';
import 'package:provider/provider.dart';

import 'list_of_notification.dart';

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;

  setMessagesInBackground(
      {'title': notification!.title, 'body': notification.body});
  print('A Background message just showed up :  ${message.messageId}');
}

void main() async {
  // firebase App initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LocalNotifyprov>(
              create: (_) => LocalNotifyprov())
        ],
        child: MaterialApp(
          title: 'Push Notification',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // List<Map<String, dynamic>> data = [];

  late Future<int> badge;

  Future<void> getNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
    );

    // flutter local notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // Firebase local notification plugin
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    //Firebase messaging
    await FirebaseMessaging.instance.getToken().then((token) => print(token));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // print(notification.body);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );

        Provider.of<LocalNotifyprov>(context, listen: false)
            .setMessagesInForground(
                {'title': notification.title, 'body': notification.body});
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getNotification();

    badge = Provider.of<LocalNotifyprov>(context, listen: false).badge();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed() async {
    Provider.of<LocalNotifyprov>(context, listen: false).onResumed();
  }

  void onPaused() {}
  void onInactive() {
    print('Inactive');
  }

  void onDetached() {
    print('detached');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton:
          Consumer<LocalNotifyprov>(builder: (context, dta, child) {
        int badge = dta.newNotification;
        // int badge = dta.noti();

        return FloatingActionButton.extended(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ListOfNotification()));
            Provider.of<LocalNotifyprov>(context, listen: false).clearBadge();
          },
          label: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications,
                size: 40,
              ),
              badge == 0
                  ? Container()
                  : Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        alignment: Alignment.center,
                        child: Text('$badge'),
                      ),
                    )
            ],
          ),
        );
      }),
      body: const Center(
        child: Text('hello'),
      ),
    );
  }
}
