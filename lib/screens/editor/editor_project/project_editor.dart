import 'package:flutter/material.dart';
import 'package:flutter_website_app/screens/editor/mode.dart';

import 'project_editor_form.dart';

class ProjectEditorScreen extends StatelessWidget {
  static const String routeName = '/add-project';

  final Mode _mode;
  final Map _toEdit;

  ProjectEditorScreen({toEdit})
      : _toEdit = toEdit,
        _mode = (toEdit == null) ? Mode.Add : Mode.Edit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('${_mode.stringValue} Project'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/add_screen_background.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
                child: SingleChildScrollView(
                    child: ProjectEditorForm(toEdit: _toEdit))),
          ),
        ],
      ),
    );
  }
}
