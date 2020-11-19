import 'package:flutter/material.dart';
import 'package:flutter_website_app/screens/add_book/add_book.dart';
import 'package:refreshable_reorderable_list/refreshable_reorderable_list.dart';
import 'package:flutter_website_app/models/book.dart';
import 'package:flutter_website_app/providers/books_provider.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';
import 'package:flutter_website_app/widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';

class BooksPage extends PageToDisplay {
  String get stringValue => 'Books';
  Widget get widget => _BooksList();
  String get addScreenRoute => AddBookScreen.routeName;
}

class _BooksList extends StatelessWidget {
  void _deleteBook(BuildContext context, Book book) async {
    final success = await context.read<BooksProvider>().deleteBook(book);
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? "Book eliminated succesfully."
            : "Error while eliminating book!")));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).accentColor,
      onRefresh: () => context.read<BooksProvider>().fetchBooks(),
      child: RefreshableReorderableListView(
        physics: AlwaysScrollableScrollPhysics(),
        onReorder: (oldIndex, newIndex) {
          context.read<BooksProvider>().updateBooksOrder(oldIndex, newIndex);
        },
        padding: EdgeInsets.all(8.0),
        children: context
            .watch<BooksProvider>()
            .books
            .map((b) => CustomListTile(
                title: b.title,
                imgUrl: b.imgUrl,
                onDismiss: (_) => _deleteBook(context, b)))
            .toList(),
      ),
    );
  }
}
