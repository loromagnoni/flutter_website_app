import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_website_app/helpers/firestore_helper.dart';
import 'package:flutter_website_app/models/project.dart';

class ProjectsProvider with ChangeNotifier {
  ProjectsProvider() {
    fecthProjects();
  }

  List<Project> _projects = [];

  List<Project> get projects {
    _projects.sort((a, b) => a.sortIndex - b.sortIndex);
    return _projects;
  }

  Future<void> fecthProjects() async {
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

  Future<void> addProject(Project toAdd) async {
    toAdd.sortIndex = _getNewSortIndex();
    await FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_PROJECTS_COLLECTION)
        .add(FirestoreHelper.fromProjectToMap(toAdd));
    fecthProjects();
  }

  Future<void> updateProject(Project toAdd) async {
    await FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_PROJECTS_COLLECTION)
        .doc(toAdd.id)
        .update(FirestoreHelper.fromProjectToMap(toAdd));
    fecthProjects();
  }

  int _getNewSortIndex() => _projects.length;

  Future<bool> deleteProject(Project toDelete) {
    return FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_PROJECTS_COLLECTION)
        .doc(toDelete.id)
        .delete()
        .then((_) {
      fecthProjects();
      return true;
    }).catchError((_) {
      fecthProjects();
      notifyListeners();
      return false;
    });
  }

  void updateProjectsOrder(oldIndex, newIndex) {
    if (oldIndex > newIndex) {
      for (int i = newIndex; i < oldIndex; i++) {
        applyToSortIndex(i, 1);
      }
    } else {
      for (int i = newIndex; i > oldIndex; i--) {
        applyToSortIndex(i, -1);
      }
    }
    _projects[oldIndex].sortIndex = newIndex;
    notifyListeners();
  }

  void applyToSortIndex(i, delta) {
    _projects[i].sortIndex += delta;
    _updateSortIndex(i);
  }

  void _updateSortIndex(i) {
    FirebaseFirestore.instance
        .collection(FirestoreHelper.FIREBASE_PROJECTS_COLLECTION)
        .doc(_projects[i].id)
        .update({FirestoreHelper.booksSortAttribute: _projects[i].sortIndex});
  }
}
