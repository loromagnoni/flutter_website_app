import 'package:flutter/material.dart';
import 'package:flutter_website_app/models/project.dart';
import 'package:flutter_website_app/providers/projects_provider.dart';
import 'package:flutter_website_app/screens/editor/editor_project/project_editor.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';
import 'package:flutter_website_app/widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:refreshable_reorderable_list/refreshable_reorderable_list.dart';

class ProjectPage extends PageToDisplay {
  String get stringValue => 'Projects';
  Widget get widget => _ProjectList();
  String get addScreenRoute => ProjectEditorScreen.routeName;
}

class _ProjectList extends StatelessWidget {
  void _deleteProject(BuildContext context, Project project) async {
    final success =
        await context.read<ProjectsProvider>().deleteProject(project);
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? "Project eliminated succesfully."
            : "Error while eliminating project!")));
  }

  void _editProject(BuildContext context, Project toEdit) {
    Navigator.pushNamed(context, ProjectEditorScreen.routeName,
        arguments: Project.toMap(toEdit));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).accentColor,
      onRefresh: () => context.read<ProjectsProvider>().fecthProjects(),
      child: RefreshableReorderableListView(
        physics: AlwaysScrollableScrollPhysics(),
        onReorder: (oldIndex, newIndex) {
          context
              .read<ProjectsProvider>()
              .updateProjectsOrder(oldIndex, newIndex);
        },
        padding: EdgeInsets.all(8.0),
        children: context
            .watch<ProjectsProvider>()
            .projects
            .map(
              (p) => CustomListTile(
                title: p.title,
                date: DateFormat("dd-MM-yyyy").format(p.date),
                imgUrl: p.imgUrl,
                onTap: () => _editProject(context, p),
                onDismiss: (_) => _deleteProject(context, p),
              ),
            )
            .toList(),
      ),
    );
  }
}
