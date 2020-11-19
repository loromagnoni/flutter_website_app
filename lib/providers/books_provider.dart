import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website_app/helpers/firestore_helper.dart';
import 'package:flutter_website_app/models/book.dart';

class BooksProvider with ChangeNotifier {
  BooksProvider() {
    fetchBooks();
  }

  List<Book> _books = [];

  List<Book> get books {
    _books.sort((a, b) => a.sortIndex - b.sortIndex);
    return _books;
  }

  Future<void> addBook(Book toAdd) async {
    toAdd.sortIndex = _getNewSortIndex();
    await FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .add(FirestoreHelper.fromBookToMap(toAdd));
    fetchBooks();
  }

  int _getNewSortIndex() {
    return _books.length;
  }

  Future<void> fetchBooks() async {
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
      fetchBooks();
      return true;
    }).catchError((_) {
      fetchBooks();
      notifyListeners();
      return false;
    });
  }

  void updateBooksOrder(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex > newIndex) {
      for (int i = newIndex; i < oldIndex; i++) {
        applyToSortIndex(i, 1);
      }
    } else {
      for (int i = newIndex; i > oldIndex; i--) {
        applyToSortIndex(i, -1);
      }
    }
    applyToSortIndex(oldIndex, newIndex - oldIndex);
    notifyListeners();
  }

  void applyToSortIndex(i, delta) {
    _books[i].sortIndex += delta;
    _updateSortIndex(i);
  }

  void _updateSortIndex(i) {
    FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .doc(_books[i].id)
        .update({FirestoreHelper.booksSortAttribute: _books[i].sortIndex});
  }
}
