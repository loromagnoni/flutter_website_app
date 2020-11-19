import 'package:flutter/material.dart';

import 'add_book_form.dart';

class AddBookScreen extends StatelessWidget {
  static const String routeName = '/add-book';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: AddBookForm()),
      ),
    );
  }
}
