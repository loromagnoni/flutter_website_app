import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_website_app/providers/books_provider.dart';
import 'package:flutter_website_app/providers/projects_provider.dart';
import 'package:flutter_website_app/screens/loading.dart';
import 'package:flutter_website_app/screens/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => BooksProvider()),
      ],
      child: MaterialApp(home: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          } else {
            return LoadingScreen();
          }
        });
  }
}
