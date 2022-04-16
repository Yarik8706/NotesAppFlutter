import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  bool isStart;
  Function onPressed;

  AnimatedIconButton({Key key, this.isStart, this.onPressed}) : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState(isStart, onPressed);
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
        with SingleTickerProviderStateMixin{
  Animation<double> animation;
  AnimationController controller;

  final bool isStart;
  final Function onTap;

  _AnimatedIconButtonState(this.isStart, this.onTap);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    setRotation(90);
    print(controller.value);

    if(isStart){
      controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void setRotation(int degrees){
    final angle = degrees * pi / 180;

    animation = Tween<double>(begin: 0, end: angle).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: IconButton(
            splashRadius: 22,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              onTap();
            }),
        builder: (context, child) => Transform.rotate(
          angle: animation.value,
          child: child
        ));
  }
}
