
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
  late Animation<Offset> _animation;
  late AnimationController _animationController;
  final TickerProviderStateMixin _tickerProviderStateMixin;


  MyBird(this._tickerProviderStateMixin) {
    _animationController = AnimationController(vsync: _tickerProviderStateMixin,
    duration: Duration(milliseconds: 500));
    _animation = Tween<Offset>(begin: Offset(0,0.5),
        end: Offset(0, 0))
        .chain(CurveTween(curve: Curves.decelerate))
        .animate(_animationController);
    _animationController.repeat(reverse: true);
  }


  Widget build() {
    return AnimatedContainer(
      alignment: Alignment(0,birdYPos),
      duration: Duration(milliseconds: 0),
      color: Colors.blue,
      child: SlideTransition(
          position: _animation,
          child: Image(key: keyBird, image: AssetImage('assets/images/bird.png'),)),
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