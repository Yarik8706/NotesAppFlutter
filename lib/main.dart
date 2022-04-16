import 'package:flutter/material.dart';
import 'package:notes_app/pages/main_notes_page.dart';
import 'package:notes_app/pages/trash_notes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        cursorColor: Colors.grey,
        textTheme: const TextTheme(
          headline5: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 24
          ),
          bodyText2: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20
          ),
          bodyText1: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 18
          ),
          subtitle2: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14
          ),
        ),
      ),
      initialRoute: '/note_list',
      routes: {
        '/note_list': (context) => const MainNotesPage(),
        '/trash_note_list': (context) => const TrashNotesPage()
      },
    );
  }
}
