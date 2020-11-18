import 'package:flutter/material.dart';
import 'package:flutter_website_app/widgets/custom_drawer.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';
import 'package:flutter_website_app/screens/management/projects_page.dart';

class ManagementScreen extends StatefulWidget {
  static const String routeName = '/management';
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  PageToDisplay _page = ProjectPage();

  void _setPage(PageToDisplay p) {
    setState(() => _page = p);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: Text(_page.stringValue), actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    Navigator.pushNamed(context, _page.addScreenRoute))
          ]),
          drawer: CustomDrawer(selectedPage: _page, onItemTap: _setPage),
          body: AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: _page.widget)),
    );
  }
}
