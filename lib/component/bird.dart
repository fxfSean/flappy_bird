
import 'dart:math';

import 'package:flappy_bird/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBird {
  GlobalKey keyBird = GlobalKey();
  double birdYPos = 0;
  double currentHeight = 0;
  double downVelocity = 0;
  double fallDownDistance = 0;



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

  void updateHeight(double time) {
    downVelocity = -4.9 * time;
    downVelocity = min(downVelocity, Constants.maxDownVelocity);
    fallDownDistance = downVelocity * time + 2.7 * time;
    birdYPos = currentHeight - fallDownDistance;
  }

}