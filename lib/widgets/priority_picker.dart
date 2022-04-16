import 'package:flutter/material.dart';

class PriorityPicker extends StatefulWidget {

  static List<Color> priorityColors = [Colors.green, Colors.lightGreen, Colors.red];

  final Function(int) onTap;
  final int selectedIndex;
  const PriorityPicker({Key key, this.onTap, this.selectedIndex}) : super(key: key);
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  Color selectedIndex;
  List<String> priorityText = ['Low', 'High', 'Very High'];

  @override
  Widget build(BuildContext context) {
    selectedIndex ??= PriorityPicker.priorityColors[widget.selectedIndex];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = PriorityPicker.priorityColors[index];
              });
              widget.onTap(index);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width / 3,
              height: 70,
              child: Container(
                child: Center(
                  child: Text(priorityText[index],
                      style: TextStyle(
                          color: PriorityPicker.priorityColors.indexOf(selectedIndex) == index
                              ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                decoration: BoxDecoration(
                    color: PriorityPicker.priorityColors.indexOf(selectedIndex) == index
                        ? PriorityPicker.priorityColors[index]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: PriorityPicker.priorityColors.indexOf(selectedIndex) == index
                        ? Border.all(width: 2, color: Colors.black)
                        : Border.all(width: 0,color: Colors.transparent)),
              ),
            ),
          );
        },
      ),
    );
  }
}


