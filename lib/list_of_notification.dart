import 'package:flutter/material.dart';
import 'package:my_sns/local_notify.dart';
import 'package:provider/provider.dart';

class ListOfNotification extends StatefulWidget {
  const ListOfNotification({Key? key}) : super(key: key);

  @override
  State<ListOfNotification> createState() => _ListOfNotificationState();
}

class _ListOfNotificationState extends State<ListOfNotification> {
  late Future<List<Map<String, dynamic>>> fcm;
  @override
  void initState() {
    fcm = Provider.of<LocalNotifyprov>(context, listen: false).getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data =
        Provider.of<LocalNotifyprov>(context, listen: false).allNotifications;
    print('======p====${data.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fcm,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>>? data = snapshot.data!;
            print(data.length);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.message),
                title: Text('${data[index]['title']}'),
                subtitle: Text('${data[index]['body']}'),
              ),
            );
          }
          return Text('data');
        },
      ),
      // body: ListView.builder(
      //   itemCount: data.length,
      //   itemBuilder: (context, index) => ListTile(
      //     leading: const Icon(Icons.message),
      //     title: Text('${data[index]['title']}'),
      //     subtitle: Text('${data[index]['body']}'),
      //   ),
      // ),
    );
  }
}
