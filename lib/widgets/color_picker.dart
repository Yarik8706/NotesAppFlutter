import 'package:flutter/material.dart';

List<Color> colors = [
  const Color(0xFFFFFFFF),
  const Color(0xffF28B83),
  const Color(0xFFFCBC05),
  const Color(0xFFFFF476),
  const Color(0xFFCBFF90),
  const Color(0xFFA7FEEA),
  const Color(0xFFE6C9A9),
  const Color(0xFFE8EAEE),
  const Color(0xFFA7FEEA),
  const Color(0xFFCAF0F8)
];

class ColorPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  const ColorPicker({Key key, this.onTap, this.selectedIndex}) : super(key: key);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    selectedIndex ??= widget.selectedIndex;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              child: Container(
                child: Center(
                    child: selectedIndex == index
                        ? const Icon(Icons.done)
                        : Container()),
                decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}