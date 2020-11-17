import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website_app/helpers/firestore_helper.dart';
import 'package:flutter_website_app/models/book.dart';

class BooksProvider with ChangeNotifier {
  BooksProvider() {
    _fetchBooks();
  }

  List<Book> _books = [];

  List<Book> get books {
    _books.sort((a, b) => a.sortIndex - b.sortIndex);
    return _books;
  }

  void _fetchBooks() async {
    _books = [];
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

  Future<bool> deleteBook(Book toDelete) {
    return FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .doc(toDelete.id)
        .delete()
        .then((_) {
      _fetchBooks();
      return true;
    }).catchError((_) {
      _fetchBooks();
      notifyListeners();
      return false;
    });
  }

  void updateBooksOrder(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex--;
    int switching = findIndexBySortIndex(oldIndex);
    int switched = findIndexBySortIndex(newIndex);
    FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .doc(_books[switching].id)
        .update({FirestoreHelper.booksSortAttribute: newIndex});
    FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .doc(_books[switched].id)
        .update({FirestoreHelper.booksSortAttribute: oldIndex});
    _books[switching].sortIndex = newIndex;
    _books[switched].sortIndex = oldIndex;
    notifyListeners();
  }

  int findIndexBySortIndex(int index) {
    for (int i = 0; i < _books.length; i++) {
      if (_books[i].sortIndex == index) return i;
    }
    return -1;
  }
}
