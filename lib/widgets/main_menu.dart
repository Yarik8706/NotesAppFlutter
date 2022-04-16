import 'package:flutter/material.dart';
import 'package:notes_app/database/note_database.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int notesCount;
  int emptyNotesCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          splashRadius: 22,
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.sticky_note_2_outlined, color: Colors.black),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text('Все заметки', style: Theme.of(context).textTheme.bodyText1),
                        const Spacer(flex: 3),
                        notesCount != 0 || notesCount != null ?
                            Text('$notesCount', style: Theme.of(context).textTheme.bodyText1)
                            : Container()
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/note_list', (route) => false);
                    },
                  ),
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.delete_outline, color: Colors.black),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text('Корзина', style: Theme.of(context).textTheme.bodyText1),
                        const Spacer(flex: 3),
                        emptyNotesCount != 0 || emptyNotesCount != null ?
                        Text('$emptyNotesCount', style: Theme.of(context).textTheme.bodyText1)
                            : Container()
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/trash_note_list', (route) => false);
                    },
                  ),
                ],
              ),
            ),
            const ListTile(
              title: Text('1'),
            ),
            const ListTile(
              title: Text('2'),
            ),
            const ListTile(
              title: Text('3'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData(){
    NoteDatabase.initializeDatabase('notes').then((database) {
      NoteDatabase.getNoteList(database).then((value) {
        setState(() {
          notesCount = value.length;
        });
      });
    });
    NoteDatabase.initializeDatabase('trash_notes').then((database) {
      NoteDatabase.getNoteList(database).then((value) {
        setState(() {
          emptyNotesCount = value.length;
        });
      });
    });
  }
}
