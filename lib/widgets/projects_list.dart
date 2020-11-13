import 'package:flutter/material.dart';
import 'package:flutter_website_app/widgets/page_to_display.dart';

class ProjectPage extends PageToDisplay {
  String get stringValue => 'Projects';
  Widget get widget => _ProjectList();
}

class _ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: Container(color: Colors.green))],
    );
  }
}
