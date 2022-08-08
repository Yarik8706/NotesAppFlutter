import 'package:flutter/material.dart';
import 'package:notes_app/modal_class/notes.dart';

class NotesSearchScreen extends SearchDelegate<Note> {
  final List<Note> notes;
  List<Note> filteredNotes = [];

  NotesSearchScreen({this.notes});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
        hintColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headline6: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ));
    assert(theme != null);
    return theme;
  }

  @override // Действие которое будет происходить во время нажатия на крестик
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        splashRadius: 22,
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          if(query == ''){
            close(context, null);
            return;
          }
          query = '';
        },
      )
    ];
  }

  @override // Стрелочка которая для выхода
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') {
      return _buildRequestNotEntered();
    } else {
      filteredNotes = [];
      _getFilteredList(notes);
      if (filteredNotes.isEmpty) {
        return _buildNotesNotFound();
      } else {
        return _buildNotesFound();
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return _buildRequestNotEntered();
    } else {
      filteredNotes = [];
      _getFilteredList(notes);
      if (filteredNotes.isEmpty) {
        return _buildNotesNotFound();
      } else {
        return _buildNotesFound();
      }
    }
  }

  Widget _buildRequestNotEntered(){
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.search,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'Enter a note to search.',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
    );
  }

  Widget _buildNotesFound(){
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: filteredNotes.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(
              Icons.note,
              color: Colors.black,
            ),
            title: Text(
              filteredNotes[index].title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black),
            ),
            subtitle: Text(
              filteredNotes[index].description,
              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            onTap: () {
              close(context, filteredNotes[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotesNotFound() {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'No results found',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
    );
  }

  List<Note> _getFilteredList(List<Note> note) {
    for (int i = 0; i < note.length; i++) {
      if (note[i].title.toLowerCase().contains(query) ||
          note[i].description.toLowerCase().contains(query)) {
        filteredNotes.add(note[i]);
      }
    }
    return filteredNotes;
  }
}
