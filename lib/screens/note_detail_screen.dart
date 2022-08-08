import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/database/note_database.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/widgets/priority_picker.dart';
import 'package:notes_app/widgets/color_picker.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final Database db;

  const NoteDetailScreen(this.note, this.db, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteDetailScreenState(note, db);
}

class NoteDetailScreenState extends State<NoteDetailScreen> {

  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Database notesDatabase;
  int color;

  bool _isEditTitle = false;

  NoteDetailScreenState(this.note, this.notesDatabase);

  @override
  void initState() {
    super.initState();
    note.title = note.title == '' ? 'Без названия' : note.title;

  }

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    return Scaffold(
      body: ListView(
          children: [
            AnimatedContainer(
              color: colors[color],
              duration: const Duration(seconds: 0),
              height: _isEditTitle ? 125 : 50,
              child: _isEditTitle ? Column(
                children: [
                  _buildBaseNavbarWidgets(),
                  _buildEditTitleWidget()
                ],
              ) : _buildBaseNavbarWidgets()
            ),
            GestureDetector(
              onTap: () => setState(() => _isEditTitle = false),
              onTapCancel: () => setState(() => _isEditTitle = false),
              onLongPress: () => setState(() => _isEditTitle = false),
              onPanCancel: () => {
                if(_isEditTitle) {
                  setState(() => _isEditTitle = false)
                }
              },
              onPanEnd: (details) => setState(() => _isEditTitle = false),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ColorFiltered(
                  colorFilter: _isEditTitle ? const ColorFilter.mode(
                      Colors.black87, BlendMode.darken)
                      : const ColorFilter.mode(Colors.white, BlendMode.darken),
                  child: Container(
                    color: colors[color],
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              maxLength: 500,
                              controller: descriptionController,
                              style: Theme.of(context).textTheme.bodyText1,
                              onChanged: (value) {
                                updateDescription();
                              },
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Описание',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }

  void showEmptyDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "У заметки отсутствует текст!",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text('Текст заметки не должен быть пустым.',
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text("Ясно",
                  style: Theme.of(context).textTheme.bodyText2
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Все равно выйти",
                  style: Theme.of(context).textTheme.bodyText2
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
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
            "Удалить заметку?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text(note.isTrash ? "Вы действительно хотите удалить заметку безвозвратно?"
              : "Вы действительно хотите отправить заметку в корзину?",
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
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: Container(
                    color: const Color(0xff757575),
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                            )
                        ),
                        child: Column(
                          children: [
                            PriorityPicker(
                              selectedIndex: PriorityPicker.priorityColors.indexOf(note.priority),
                              onTap: (index) {
                                note.priority = PriorityPicker.priorityColors[index];
                              },
                            ),
                            ColorPicker(
                              selectedIndex: note.color,
                              onTap: (index) {
                                setState(() {
                                  color = index;
                                });
                                note.color = index;
                              },
                            ),
                            ElevatedButton(
                              child: Text('Готово', style: Theme.of(context).textTheme.bodyText2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                    )
                ),
              ),
          );
        }
    );
  }

  Widget _buildNavbarIconButtons() {
    return Row(
      children: [
        IconButton(
          splashRadius: 22,
          icon: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {
            _showSettingModalBottomSheet();
          },
        ),
        note.id == null ? Container() : IconButton(
          splashRadius: 22,
          icon: const Icon(Icons.delete, color: Colors.black),
          onPressed: () {
            showDeleteDialog(context);
          },
        )
      ],
    );
  }

  Widget _buildIconExit(){
    return IconButton(
        splashRadius: 22,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          if(_isEditTitle){
            setState((){
              _isEditTitle = false;
            });
          } else {
            if(note.description == ''){
              if(note.title != 'Без названия'){
                showEmptyDescriptionDialog(context);
              }
              else if(note.title == 'Без названия'){
                moveToLastScreen();
                return;
              }
            } else {
              _save();
            }
          }
        });
  }

  Widget _buildBaseNavbarWidgets() {
    final isCutTitle = note.title.length > 15 && MediaQuery.of(context).size.width > note.title.length*10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isEditTitle ? Transform.rotate(angle: 90 * pi / 180, child: _buildIconExit()) : _buildIconExit(),
        // !_isEditTitle ? Container() : IconButton( // TODO add favourite notes
        //   splashRadius: 22,
        //   icon: const Icon(
        //     Icons.star,
        //     color: Colors.yellowAccent,
        //   ),
        //   onPressed: () {
        //
        //   },
        // ),
        _isEditTitle ? Container() : TextButton(
          child: Row(
            children: [
              Text(isCutTitle ? note.title.substring(0, 14) : note.title,
                  style: Theme.of(context).textTheme.headline5
              ),
              isCutTitle ? Text("...",
                style: Theme.of(context).textTheme.headline5,
              ) : Container(),
            ],
          ),
          onPressed: () {
            setState(() {
              _isEditTitle = true;
            });
          },
        ),
        _isEditTitle ? Container() : _buildNavbarIconButtons()
      ],
    );
  }

  Widget _buildEditTitleWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: titleController,
        maxLength: 50,
        style: Theme.of(context).textTheme.bodyText2,
        onChanged: (value) {
          updateTitle();
        },
        cursorHeight: 30,
        decoration: const InputDecoration(
          hintText: 'Название',
          border: InputBorder.none
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id != null) {
      await NoteDatabase.updateNote(notesDatabase, note);
    } else {
      await NoteDatabase.insertNote(notesDatabase, note);
    }
  }

  void _delete() async {
    if(!note.isTrash) {
      note.isTrash = true;
      NoteDatabase.initializeDatabase('trash_notes').then((database) => {
        NoteDatabase.moveToOtherDB(notesDatabase, note, database)
      });
    }
    await NoteDatabase.deleteNote(notesDatabase, note.id);
    moveToLastScreen();
  }
}
