import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_website_app/models/book.dart';
import 'package:flutter_website_app/models/project.dart';

class FirestoreHelper {
  static const String FIREBASE_PROJECTS_COLLECTION = 'projects';
  static const String FIREBASE_BOOKS_COLLECTION = 'books';

  static String get booksSortAttribute => _BookSchema.SORT_INDEX;

  static Project toProject(QueryDocumentSnapshot p) {
    return Project(
      id: p.id,
      title: p[_ProjectSchema.TITLE],
      description: p[_ProjectSchema.DESCRIPTION],
      date: (p[_ProjectSchema.DATE]).toDate(),
      imgUrl: p[_ProjectSchema.IMAGE_URL],
      youtubeLink: p[_ProjectSchema.YOUTUBE_URL],
      gitHubLink: p[_ProjectSchema.GITHUB_URL],
      sortIndex: p[_ProjectSchema.SORT_INDEX],
    );
  }

  static Book toBook(QueryDocumentSnapshot b) {
    return Book(
      id: b.id,
      title: b[_BookSchema.TITLE],
      imgUrl: b[_BookSchema.IMAGE_URL],
      sortIndex: b[_BookSchema.SORT_INDEX],
    );
  }

  static fromBookToMap(Book b) {
    return {
      _BookSchema.TITLE: b.title,
      _BookSchema.IMAGE_URL: b.imgUrl,
      _BookSchema.SORT_INDEX: b.sortIndex,
    };
  }

  static fromProjectToMap(Project p) {
    return {
      _ProjectSchema.TITLE: p.title,
      _ProjectSchema.IMAGE_URL: p.imgUrl,
      _ProjectSchema.SORT_INDEX: p.sortIndex,
      _ProjectSchema.YOUTUBE_URL: p.youtubeLink,
      _ProjectSchema.GITHUB_URL: p.gitHubLink,
      _ProjectSchema.DESCRIPTION: p.description,
      _ProjectSchema.DATE: p.date,
    };
  }
}

class _ProjectSchema {
  static const TITLE = 'title';
  static const DESCRIPTION = 'description';
  static const DATE = 'date';
  static const IMAGE_URL = 'img_url';
  static const YOUTUBE_URL = 'youtube_url';
  static const GITHUB_URL = 'github_url';
  static const SORT_INDEX = 'sort_index';
}

class _BookSchema {
  static const TITLE = 'title';
  static const IMAGE_URL = 'img_url';
  static const SORT_INDEX = 'sort_index';
}
