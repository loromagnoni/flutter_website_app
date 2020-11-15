import 'package:flutter/material.dart';
import 'package:flutter_website_app/providers/books_provider.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';
import 'package:flutter_website_app/widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';

class BooksPage extends PageToDisplay {
  String get stringValue => 'Books';
  Widget get widget => _BooksList();
}

class _BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: context
          .watch<BooksProvider>()
          .books
          .map((p) => CustomListTile(title: p.title, imgUrl: p.imgUrl))
          .toList(),
    );
  }
}
