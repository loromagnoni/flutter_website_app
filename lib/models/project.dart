import 'package:flutter/material.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String imgUrl;
  final DateTime date;
  final String youtubeLink;
  final String gitHubLink;

  Project(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.date,
      @required this.imgUrl,
      this.youtubeLink,
      this.gitHubLink});
}
