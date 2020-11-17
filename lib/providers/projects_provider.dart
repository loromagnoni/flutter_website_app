import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_website_app/helpers/firestore_helper.dart';
import 'package:flutter_website_app/models/project.dart';

class ProjectsProvider with ChangeNotifier {
  ProjectsProvider() {
    _fecthProjects();
  }

  List<Project> _projects = [];

  List<Project> get projects {
    _projects.sort((a, b) => a.sortIndex - b.sortIndex);
    return _projects;
  }

  void _fecthProjects() async {
    _projects = [];
    QuerySnapshot _querySnapshot = await FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_PROJECTS_COLLECTION)
        .get();
    _querySnapshot.docs.forEach(
      (p) {
        _projects.add(FirestoreHelper.toProject(p));
      },
    );
    notifyListeners();
  }

  Future<bool> deleteProject(Project toDelete) {
    return FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_PROJECTS_COLLECTION)
        .doc(toDelete.id)
        .delete()
        .then((_) {
      _fecthProjects();
      return true;
    }).catchError((_) {
      _fecthProjects();
      notifyListeners();
      return false;
    });
  }

  void updateProjectsOrder(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex--;
    int switching = findIndexBySortIndex(oldIndex);
    int switched = findIndexBySortIndex(newIndex);
    FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .doc(_projects[switching].id)
        .update({FirestoreHelper.booksSortAttribute: newIndex});
    FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_BOOKS_COLLECTION)
        .doc(_projects[switched].id)
        .update({FirestoreHelper.booksSortAttribute: oldIndex});
    _projects[switching].sortIndex = newIndex;
    _projects[switched].sortIndex = oldIndex;
    notifyListeners();
  }

  int findIndexBySortIndex(int index) {
    for (int i = 0; i < _projects.length; i++) {
      if (_projects[i].sortIndex == index) return i;
    }
    return -1;
  }
}
