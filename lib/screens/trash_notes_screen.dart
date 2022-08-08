import 'package:flutter/material.dart';
import 'package:notes_app/database/note_database.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail_screen.dart';
import 'package:notes_app/widgets/main_menu.dart';
import 'package:notes_app/widgets/note_list.dart';
import 'package:sqflite/sqflite.dart';

class TrashNotesPage extends StatefulWidget {
  const TrashNotesPage({Key key}) : super(key: key);

  @override
  State<TrashNotesPage> createState() => _TrashNotesPageState();
}

class _TrashNotesPageState extends State<TrashNotesPage> {
  Database noteDatabase;
  List<Note> noteList = [];
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    NoteDatabase.initializeDatabase('trash_notes').then((database) {
      noteDatabase = database;
    });
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
                child: Text('Корзина пуста!',
                    style: Theme.of(context).textTheme.bodyText2
                )
            )
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
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Корзина', style: Theme.of(context).textTheme.headline5),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        FutureBuilder(
          future: NoteDatabase.getNoteList(noteDatabase),
          builder: (context, noteListSnapshot) {
            if(noteListSnapshot.data == null) {
              return Container();
            }
            return Row(
              children: [
                IconButton(
                  splashRadius: 22,
                  icon: const Icon(
                    Icons.delete_sweep,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showDeleteDialog(context);
                    });
                  },
                ),
                IconButton(
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
          },
        )
      ],
    );
  }

  void navigateToDetail(Note note) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteDetailScreen(note, noteDatabase))
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Очистить корзину?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text("Вы действительно хотите очистить корзину?",
              style: Theme.of(context).textTheme.bodyText1
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Нет",
                  style: Theme.of(context).textTheme.bodyText2
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Да",
                  style: Theme.of(context).textTheme.bodyText2
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  NoteDatabase.clearDatabase(noteDatabase);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
