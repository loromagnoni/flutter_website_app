import 'package:flutter/material.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String imgUrl;
  final DateTime date;
  final String youtubeLink;
  final String gitHubLink;
  int sortIndex;

  Project(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.date,
      @required this.imgUrl,
      this.youtubeLink,
      this.gitHubLink,
      @required this.sortIndex});

  static Project fromMap(Map map) {
    return Project(
        id: map["id"],
        title: map["title"],
        imgUrl: map["img_url"],
        description: map["description"],
        date: map["date"],
        youtubeLink: map["youtube_link"],
        gitHubLink: map["github_link"],
        sortIndex: map["sortIndex"]);
  }
}
