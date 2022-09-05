import 'package:flutter/material.dart';
import 'package:my_sns/local_notify.dart';
import 'package:provider/provider.dart';

class ListOfNotification extends StatelessWidget {
  const ListOfNotification({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data =
        Provider.of<LocalNotifyprov>(context, listen: false).allNotifications;
    print(data.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notifications'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.message),
          title: Text('${data[index]['title']}'),
          subtitle: Text('${data[index]['body']}'),
        ),
      ),
    );
  }
}
