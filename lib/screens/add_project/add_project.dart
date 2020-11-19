import 'package:flutter/material.dart';

import 'add_project_form.dart';

class AddProjectScreen extends StatelessWidget {
  static const String routeName = '/add-project';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: SingleChildScrollView(child: AddProjectForm())),
      ),
    );
  }
}
