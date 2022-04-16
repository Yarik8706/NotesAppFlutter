import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/widgets/color_picker.dart';

class NoteList extends StatelessWidget {

  final List<Note> notes;
  final int axisCount;
  final Function navigateToDetail;

  const NoteList({Key key, this.notes, this.axisCount, this.navigateToDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: notes.length,
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemBuilder: (BuildContext context, int index) =>
          GestureDetector(
            onTap: () {
              navigateToDetail(notes[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: colors[notes[index].color],
                        border: Border.all(width: 2, color: notes[index].priority),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    notes[index].description ?? '',
                                    style: Theme.of(context).textTheme.bodyText1)
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        notes[index].title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        notes[index].date,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
    );
  }
}
