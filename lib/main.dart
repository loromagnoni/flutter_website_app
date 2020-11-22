import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_website_app/providers/books_provider.dart';
import 'package:flutter_website_app/providers/projects_provider.dart';
import 'package:flutter_website_app/screens/editor/editor_book/book_editor.dart';
import 'package:flutter_website_app/screens/editor/editor_project/project_editor.dart';
import 'package:flutter_website_app/screens/loading.dart';
import 'package:flutter_website_app/screens/login.dart';
import 'package:flutter_website_app/screens/management/management.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => BooksProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.teal,
            hintColor: Colors.white,
            brightness: Brightness.dark,
            primaryColor: Color(0xFF00FFC2),
            accentColor: Color(0xFF00FFC2),
            textTheme: TextTheme(
              headline1: TextStyle(
                  color: Color(0xFF00FFC2),
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
              headline2: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              subtitle1: TextStyle(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
              bodyText1: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            )),
        initialRoute: MyApp.routeName,
        onGenerateRoute: (settings) {
          if (settings.name == BookEditorScreen.routeName) {
            return MaterialPageRoute(builder: (context) {
              return BookEditorScreen(toEdit: settings.arguments);
            });
          }
          if (settings.name == ProjectEditorScreen.routeName) {
            return MaterialPageRoute(builder: (context) {
              return ProjectEditorScreen(toEdit: settings.arguments);
            });
          }
          return null;
        },
        routes: {
          MyApp.routeName: (context) => MyApp(),
          ManagementScreen.routeName: (context) => ManagementScreen(),
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const String routeName = '/';

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
