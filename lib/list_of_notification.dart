import 'package:flutter/material.dart';

class ListOfNotification extends StatefulWidget {
  const ListOfNotification({Key? key, required this.data}) : super(key: key);
  final List<Map<String, dynamic>> data;

  @override
  State<ListOfNotification> createState() => _ListOfNotificationState();
}

class _ListOfNotificationState extends State<ListOfNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Notifications'),
        ),
        body: ListView.builder(
          itemCount: widget.data.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.message),
            title: Text('${widget.data[index]['title']}'),
            subtitle: Text('${widget.data[index]['body']}'),
          ),
        ));
  }
}
