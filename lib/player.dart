import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;

  const MyPlayer({super.key, this.playerX});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment(playerX, 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.blue,
              width: 50,
              height: 50,
            ),
        ),
      ),
    );
  }
}