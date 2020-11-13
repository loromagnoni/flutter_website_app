import 'package:flutter/material.dart';
import 'package:flutter_website_app/widgets/page_to_display.dart';

class BooksPage extends PageToDisplay {
  String get stringValue => 'Books';
  Widget get widget => _BooksList();
}

class _BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: Container(color: Colors.red))],
    );
  }
}
