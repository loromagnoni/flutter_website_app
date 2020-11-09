import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website_app/helpers/firestore_helper.dart';
import 'package:flutter_website_app/models/book.dart';

class BooksProvider with ChangeNotifier {
  BooksProvider() {
    _fetchBooks();
  }

  List<Book> _books = [];

  List<Book> get books => _books;

  void _fetchBooks() async {
    QuerySnapshot _querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .get();
    _querySnapshot.docs.forEach(
      (b) {
        _books.add(FirestoreHelper.toBook(b));
      },
    );
    notifyListeners();
  }
}
