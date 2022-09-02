// //
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:my_sns/local_notify.dart';
// import './list_of_notification.dart';
// import 'package:provider/provider.dart';

// import 'list_of_notification.dart';

// // firebase background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   RemoteNotification? notification = message.notification;

//   setMessages({'title': notification!.title, 'body': notification.body});
//   print('A Background message just showed up :  ${message.messageId}');
// }

// void main() async {
//   // firebase App initialize
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider<LocalNotifyprov>(
//               create: (_) => LocalNotifyprov())
//         ],
//         child: MaterialApp(
//           title: 'Push Notification',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//           ),
//           home: const MyHomePage(),
//         ));
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<Map<String, dynamic>> data = [];

//   late Future<List<Map<String, dynamic>>> fcm;

//   Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }

//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }

//   void _handleMessage(RemoteMessage message) {
//     RemoteNotification? notification = message.notification;

//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       data.add({'title': notification.title, 'body': notification.body});
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (_) => ListOfNotification(
//                 data: data,
//               )));
//     }
//   }

//   Future<void> getNotification() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//       playSound: true,
//     );

//     // flutter local notification
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     // Firebase local notification plugin
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     //Firebase messaging
//     await FirebaseMessaging.instance.getToken().then((token) => print(token));

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {
//         // print(notification.body);
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               importance: Importance.high,
//               color: Colors.blue,
//               playSound: true,
//               icon: '@mipmap/ic_launcher',
//             ),
//           ),
//         );

//         Provider.of<LocalNotifyprov>(context, listen: false).setMessagesForGnd(
//             {'title': notification.title, 'body': notification.body});
//         data.add({'title': notification.title, 'body': notification.body});
//       }
//     });
//   }

//   @override
//   void initState() {
//     getNotification();
//     // setupInteractedMessage();

//     // fcm = Provider.of<LocalNotifyprov>(context, listen: false).getAllMessage();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var a =
//     //     Provider.of<LocalNotifyprov>(context, listen: false).allNotifications;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification'),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Colors.greenAccent,
//         onPressed: () {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (_) => ListOfNotification(
//                     data: data,
//                   )));
//           Provider.of<LocalNotifyprov>(context, listen: false).clearBadge();
//         },
//         label: Consumer<LocalNotifyprov>(builder: (context, dta, child) {
//           // print('====${dta.newNotification}');
//           int badge = dta.newNotification;
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               const Icon(
//                 Icons.notifications,
//                 size: 40,
//               ),
//               badge == 0
//                   ? Container()
//                   : Positioned(
//                       top: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: const BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.red),
//                         alignment: Alignment.center,
//                         child: Text('$badge'),
//                       ),
//                     )
//             ],
//           );
//         }),
//       ),
//       body: const Center(
//         child: Text('hello'),
//       ),
//     );
//   }
// }
