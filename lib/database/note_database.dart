import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:notes_app/modal_class/notes.dart';

class NoteDatabase {
  static Future<Database> initializeDatabase(name) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '$name.db';

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE note_table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, '
            'description TEXT, priority INTEGER, color INTEGER, date TEXT, isTrash INT2)');
  }

  // Fetch Operation: Get all note objects from database
  static Future<List<Map<String, dynamic>>> getNoteMapList(Database db) async {
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query('note_table', orderBy: 'priority ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  static Future<int> insertNote(Database db, Note note) async {
    var result = await db.insert('note_table', note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  static Future<int> updateNote(Database db, Note note) async {
    var result = await db.update('note_table', note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  static Future<int> deleteNote(Database db, int id) async {
    int result = await db.rawDelete('DELETE FROM note_table WHERE id = $id');
    return result;
  }

  // Get number of Note objects in database
  static Future<int> getCount(Database db) async {
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from note_table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  static Future<List<Note>> getNoteList(Database db) async {
    var noteMapList = await getNoteMapList(db); // Get 'Map List' from database
    int count = noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  static void moveToOtherDB(Database oldDb, Note note, Database newDb) async {
    await deleteNote(oldDb, note.id);
    var noteMap = note.toMap();
    noteMap.remove('id');
    insertNote(newDb, Note.fromMapObject(noteMap));
  }
  
  static void clearDatabase(Database db){
    db.rawDelete('DELETE FROM note_table');
  }
}