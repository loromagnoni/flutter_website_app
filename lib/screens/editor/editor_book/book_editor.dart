import 'package:flutter/material.dart';

import '../mode.dart';
import 'book_editor_form.dart';

class BookEditorScreen extends StatelessWidget {
  static const String routeName = '/book-editor';
  final Mode _mode;
  final Map _toEdit;

  BookEditorScreen({toEdit})
      : _toEdit = toEdit,
        _mode = (toEdit == null) ? Mode.Add : Mode.Edit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_mode.stringValue} Book'),
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
                    child: BookEditorForm(toEdit: _toEdit))),
          ),
        ],
      ),
    );
  }
}
