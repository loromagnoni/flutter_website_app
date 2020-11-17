import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String imgUrl;
  int sortIndex;

  Book(
      {@required this.id,
      @required this.title,
      @required this.imgUrl,
      @required this.sortIndex});
}
