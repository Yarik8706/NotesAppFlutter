import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/database/note_database.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/pages/note_detail.dart';
import 'package:notes_app/pages/search_note.dart';
import 'package:notes_app/widgets/main_menu.dart';
import 'package:notes_app/widgets/note_list.dart';
import 'package:sqflite/sqflite.dart';

class MainNotesPage extends StatefulWidget {
  const MainNotesPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainNotesPageState();
}

class MainNotesPageState extends State<MainNotesPage> {

  Database noteDatabase;
  List<Note> noteList;
  int axisCount = 2;

  // @override
  // void initState() {
  //   super.initState();
  //   print("Fdgsdg");
  //    // _deleteDatabase();
  // }
  // void _deleteDatabase() async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = directory.path + 'notes.db';
  //   deleteDatabase(path);
  // }

  @override
  Widget build(BuildContext context) {
    updateListView();
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const MainMenu(),
      body: noteList == null || noteList == [] || noteList.isEmpty ? Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Нажми на кнопку ниже чтобы добавить первую заметку!',
                style: Theme.of(context).textTheme.bodyText2
            ),
          )
        )
      ) : Container(
          color: Colors.white,
          child: NoteList(notes: noteList, axisCount: axisCount, navigateToDetail: navigateToDetail)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note(title: 'Без названия', date: '', description: '', priority: Colors.green, color: 0, isTrash: false));
        },
        tooltip: 'Добавить заметку',
        shape: const CircleBorder(
            side: BorderSide(color: Colors.black, width: 2)),
        child: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Заметки', style: Theme.of(context).textTheme.headline5),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        noteList == null || noteList == [] ? Container() : IconButton(
          splashRadius: 22,
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () async {
            final Note result = await showSearch(
                context: context, delegate: NotesSearch(notes: noteList));
            if (result != null) {
              navigateToDetail(result);
            }
          },
        ),
        noteList == null || noteList == [] ? Container() : IconButton(
          splashRadius: 22,
          icon: Icon(
            axisCount == 2 ? Icons.list : Icons.grid_on,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              axisCount = axisCount == 2 ? 4 : 2;
            });
          },
        )
      ],
    );
  }

  // void _delete(BuildContext context, Note note) async {
  //   int result = await databaseHelper.deleteNote(note.id);
  //   if (result != 0) {
  //     _showSnackBar(context, 'Note Deleted Successfully');
  //     updateListView();
  //   }
  // }

  // void _showSnackBar(BuildContext context, String message) {
  //   final snackBar = SnackBar(content: Text(message));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  void navigateToDetail(Note note) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetail(note, noteDatabase)));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    if(noteDatabase != null){
      Future<List<Note>> noteListFuture = NoteDatabase.getNoteList(noteDatabase);
      noteListFuture.then((newNoteList) {
        setState(() {
          noteList = newNoteList;
        });
      });
      return;
    }
    NoteDatabase.initializeDatabase('notes').then((database) {
      noteDatabase = database;
      Future<List<Note>> noteListFuture = NoteDatabase.getNoteList(database);
      noteListFuture.then((newNoteList) {
        setState(() {
          noteList = newNoteList;
        });
      });
    });
  }
}
