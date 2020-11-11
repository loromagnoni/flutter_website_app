import 'package:flutter/material.dart';

class ManagementScreen extends StatefulWidget {
  static const String routeName = '/management';
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Website Manager"),
      ),
      drawer: ListView(children: [
        ListTile(title: Text('Projects')),
        ListTile(title: Text('Books')),
      ]),
      body: Container(),
    );
  }
}
