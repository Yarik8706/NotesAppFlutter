import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/database/note_database.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail_screen.dart';
import 'package:notes_app/screens/search_note_screen.dart';


import 'package:notes_app/widgets/main_menu.dart';
import 'package:notes_app/widgets/note_list.dart';
import 'package:sqflite/sqflite.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {

  Database noteDatabase;
  List<Note> noteList;
  int axisCount = 2;

  @override
  void initState() {
    super.initState();
    NoteDatabase.initializeDatabase('notes').then((value) => noteDatabase = value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const MainMenu(),
      body: FutureBuilder<List<Note>>(
        future: NoteDatabase.getNoteList(noteDatabase),
        builder: (context, noteListSnapshot) {
          if(noteListSnapshot.data == null) {
            return Center(
              child: Text("Загрузка...",
                  style: Theme.of(context).textTheme.bodyText2
              ),
            );
          }
          noteList = noteListSnapshot.data;
          return noteList.isEmpty ? Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Text("У вас пока нет заметок! Нажми на кнопку ниже чтобы добавить первую заметку!",
                  style: Theme.of(context).textTheme.bodyText2),
            ),
          ) : Container(
              color: Colors.white,
              child: NoteList(
                  notes: noteList,
                  axisCount: axisCount,
                  navigateToDetail: navigateToDetail
              )
          );
        },
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
      )
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
                context: context, delegate: NotesSearchScreen(notes: noteList));
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
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailScreen(note, noteDatabase)));

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
