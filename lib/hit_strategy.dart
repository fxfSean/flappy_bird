
import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/score_counter.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';

class HitStrategy {
  final MyBarrier _myBarrier;
  final MyBird _myBird;
  bool isRecorded = false;

  HitStrategy(this._myBarrier, this._myBird) {
    scoreCounter.isRecordedController.stream.listen((event) {
      isRecorded = event;
    });
  }

  bool hitTest() {
    final RenderBox birdRenderBox =
    _myBird.keyBird.currentContext?.findRenderObject() as RenderBox;
    final birdPos = birdRenderBox.localToGlobal(Offset.zero);
    final birdTopBorder = birdPos.dy;
    final birdBottomBorder = birdPos.dy + birdRenderBox.size.height;
    final birdRightBorder = birdPos.dx + birdRenderBox.size.width;

    bool hit = false;
    _myBarrier.listKeys.forEach((element) {
      final RenderBox boxBarrier =
      element.currentContext?.findRenderObject() as RenderBox;
      final barrierPos = boxBarrier.localToGlobal(Offset.zero);

      final barrierLeftBorder = barrierPos.dx;
      final barrierRightBorder = barrierPos.dx + boxBarrier.size.width;
      final barrierBottomBorder = barrierPos.dy;
      final barrierTopBorder = barrierPos.dy -
          (Constants.barrierTotalHeight - boxBarrier.size.width - 60);

      if(birdRightBorder < barrierLeftBorder || barrierLeftBorder <= 0) {
        ///第一个barrier还没过去 or 第二个barrier没完全出来，返回
        return;
      }

      if(birdRightBorder > barrierLeftBorder && birdRightBorder < barrierRightBorder){
        if(birdBottomBorder > barrierBottomBorder || birdTopBorder < barrierTopBorder){
          hit = true;
          return;
        }
      }
      if(!isRecorded && birdRightBorder > barrierRightBorder){
        scoreCounter.isRecordedController.add(true);
      }

    });
    return hit;

  }

  bool hitGround() {
    return _myBird.birdYPos > 1;
  }
}