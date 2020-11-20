import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_project_form.dart';

class AddProjectScreen extends StatelessWidget {
  static const String routeName = '/add-project';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Add Project'),
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
            child:
                Center(child: SingleChildScrollView(child: AddProjectForm())),
          ),
        ],
      ),
    );
  }
}
