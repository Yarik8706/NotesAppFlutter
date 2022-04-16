import 'package:flutter/material.dart';
import 'package:notes_app/widgets/priority_picker.dart';

class Note {
  int _id;
  String title;
  String description;
  String date;
  Color priority;
  int color;
  bool isTrash;

  Note({this.title, this.date, this.priority, this.color, this.isTrash,
      this.description});

  Note.withId(this._id, {this.title, this.date, this.priority, this.color, this.isTrash,
      this.description});

  int get id => _id;

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = title;
    map['description'] = description;
    map['priority'] = PriorityPicker.priorityColors.indexOf(priority);
    map['color'] = color;
    map['date'] = date;
    map['isTrash'] = isTrash ? 1 : 0;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    title = map['title'];
    description = map['description'];
    priority = PriorityPicker.priorityColors[map['priority']];
    color = map['color'];
    date = map['date'];
    isTrash = map['isTrash'] == 1 ? true : false;
  }
}
