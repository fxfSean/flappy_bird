
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBird {
  GlobalKey keyBird = GlobalKey();
  double birdYPos = 0;
  double currentHeight = 0;


  Widget build() {
    return AnimatedContainer(
      alignment: Alignment(0,birdYPos),
      duration: Duration(milliseconds: 0),
      color: Colors.blue,
      child: Image(key: keyBird, image: AssetImage('assets/images/bird.png'),),
    );
  }

  void resetGame() {
    birdYPos = 0;
  }

  void jump() {
    currentHeight = birdYPos;
  }

  void startGame() {
    currentHeight = birdYPos;
  }

  void updateHeight(double height) {
    birdYPos = currentHeight - height;
  }

}