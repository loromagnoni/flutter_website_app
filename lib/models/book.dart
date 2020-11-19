import 'package:flutter/material.dart';

class Book {
  String id;
  String title;
  String imgUrl;
  int sortIndex;

  Book(
      {@required this.id,
      @required this.title,
      @required this.imgUrl,
      @required this.sortIndex});

  static Book fromMap(Map map) {
    return Book(
        id: map["id"],
        title: map["title"],
        imgUrl: map["imgUrl"],
        sortIndex: map["sortIndex"]);
  }
}
