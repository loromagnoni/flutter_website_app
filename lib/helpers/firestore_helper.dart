import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_website_app/models/book.dart';
import 'package:flutter_website_app/models/project.dart';

class FirestoreHelper {
  static const String FIREBASE_PROJECTS_COLLECTION = 'projects';
  static const String FIREBASE_BOOKS_COLLECTION = 'books';

  static Project toProject(QueryDocumentSnapshot p) {
    return Project(
      title: p[_ProjectSchema.TITLE],
      description: p[_ProjectSchema.DESCRIPTION],
      date: (p[_ProjectSchema.DATE]).toDate(),
      imgUrl: p[_ProjectSchema.IMAGE_URL],
      youtubeLink: p[_ProjectSchema.YOUTUBE_URL],
      gitHubLink: p[_ProjectSchema.GITHUB_URL],
    );
  }

  static Book toBook(QueryDocumentSnapshot b) {
    return Book(
      title: b[_BookSchema.TITLE],
      imgUrl: b[_BookSchema.IMAGE_URL],
    );
  }
}

class _ProjectSchema {
  static const TITLE = 'title';
  static const DESCRIPTION = 'description';
  static const DATE = 'date';
  static const IMAGE_URL = 'img_url';
  static const YOUTUBE_URL = 'youtube_url';
  static const GITHUB_URL = 'github_url';
}

class _BookSchema {
  static const TITLE = 'title';
  static const IMAGE_URL = 'img_url';
}
