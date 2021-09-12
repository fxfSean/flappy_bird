
import 'dart:math';

import 'package:flappy_bird/strategy/score_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MyBarrier {
  static double initBarrierXPos = 2;
  static double barrierXOnePos = initBarrierXPos;
  double barrierXTwoPos = barrierXOnePos + 1.8;
  double barrierHeightOne = BarrierHeightStrategy.generateRandomHeight();
  double barrierHeightTwo = BarrierHeightStrategy.generateRandomHeight();
  List<GlobalKey> listKeys = [];

  MyBarrier(){
    init();
  }

  void init() {
    for(var i=0; i<2; i++){
      listKeys.add(GlobalKey());
    }
  }

  List<Widget> barrierBuilder(BuildContext context) {
    return [
      AnimatedContainer(
          alignment: Alignment(barrierXOnePos,1.1),
          duration: Duration(milliseconds: 0),
          child: build(context,listKeys[0], barrierHeightOne)),
      AnimatedContainer(
          alignment: Alignment(barrierXOnePos,-1),
          duration: Duration(milliseconds: 0),
          child: build(context, null,  Constants.barrierTotalHeight - barrierHeightOne)),

      AnimatedContainer(
          alignment: Alignment(barrierXTwoPos,1.1),
          duration: Duration(milliseconds: 0),
          child: build(context,listKeys[1], barrierHeightTwo)),
      AnimatedContainer(
          alignment: Alignment(barrierXTwoPos,-1),
          duration: Duration(milliseconds: 0),
          child: build(context,null, Constants.barrierTotalHeight - barrierHeightTwo)),
    ];
  }

  void updateBarrierPos() {
    if(barrierXOnePos < -2){
      barrierXOnePos += 3.7;
      barrierHeightOne = BarrierHeightStrategy.generateRandomHeight();
      scoreCounter.isRecordedController.add(false);
    } else {
      barrierXOnePos -= 0.0125;
    }
    if(barrierXTwoPos < -2){
      barrierXTwoPos += 3.7;
      barrierHeightTwo = BarrierHeightStrategy.generateRandomHeight();
      scoreCounter.isRecordedController.add(false);
    } else {
      barrierXTwoPos -= 0.0125;
    }
  }


  Widget build(BuildContext context,Key? key, double size) {
    return Container(
      key: key,
      decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
          border: Border.all(
          width: 10,
          color: Colors.green),
        borderRadius: BorderRadius.circular(15)
      ),
      width: 100,
      height: size,
    );
  }

  void resetGame() {
    barrierXOnePos = initBarrierXPos;
    barrierXTwoPos = barrierXOnePos + 1.8;
  }
}

class BarrierHeightStrategy {

  static double generateRandomHeight(){
    return 50 + Random().nextInt(250).toDouble();
  }
}