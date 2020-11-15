import 'package:flutter/material.dart';
import 'package:flutter_website_app/providers/projects_provider.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';
import 'package:flutter_website_app/widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';

class ProjectPage extends PageToDisplay {
  String get stringValue => 'Projects';
  Widget get widget => _ProjectList();
}

class _ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: context
          .watch<ProjectsProvider>()
          .projects
          .map((p) => CustomListTile(
              title: p.title, date: p.date.toIso8601String(), imgUrl: p.imgUrl))
          .toList(),
    );
  }
}
