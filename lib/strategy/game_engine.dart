
import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/component/barrier.dart';
import 'package:flappy_bird/component/bird.dart';
import 'package:flappy_bird/component/land.dart';
import 'package:flappy_bird/constants/constants.dart';
import 'package:flappy_bird/strategy/score_counter.dart';
import 'package:flutter/cupertino.dart';

import 'hit_strategy.dart';

class GameEngine {

  double time = 0;
  double height = 0;
  bool gameStarted = false;
  bool gameOver = false;
  double downVelocity = 0;
  int score = 0;
  int maxScore = 0;
  bool isRecorded = false;

  late LandArea landArea;
  late MyBarrier myBarrier;
  late HitStrategy _hitStrategy;
  late MyBird myBird;
  late OnRefreshListener _refreshListener;

  void init(TickerProviderStateMixin tickerProviderStateMixin, OnRefreshListener onRefreshListener) {
    landArea = LandArea(tickerProviderStateMixin);
    myBarrier = MyBarrier();
    myBird = MyBird();
    _hitStrategy = HitStrategy(myBarrier,myBird);
    _refreshListener = onRefreshListener;

    scoreCounter.isRecordedController.stream.listen((event) {
      if (event) {
        score++;
      }
    });
  }

  void startGame() {
    gameStarted = true;
    myBird.startGame();
    Timer.periodic(Duration(milliseconds: 15), (timer) {
      if(_hitStrategy.hitTest()){
        timer.cancel();
        _gameOver();
        return;
      }

      time += 0.0125;
      downVelocity = -4.9 * time;
      downVelocity = min(downVelocity, Constants.maxDownVelocity);
      height = downVelocity * time + 2.7 * time;
      myBird.updateHeight(height);
      _refreshListener.refresh();
      myBarrier.updateBarrierPos();
      if(_hitStrategy.hitGround()){
        timer.cancel();
        _gameOver();
      }
    });
  }

  void _gameOver(){
    gameOver = true;
    time = 0;
    gameStarted = false;
    landArea.gameOver();
    maxScore = max(maxScore, score);
    _refreshListener.refresh();
  }

  void replay(bool replay){
    if (replay) {
      _resetGame();
    }
    gameOver = false;
    _refreshListener.refresh();
  }

  void _resetGame(){
    score = 0;
    isRecorded = false;
    landArea.gameStart();
    myBarrier.resetGame();
    myBird.resetGame();
  }

  void birdJump() {
    myBird.jump();
    time = 0;
  }


  void onUserTab() {
    if (gameOver) {
      return;
    }
    if (!gameStarted){
      startGame();
    } else {
      birdJump();
    }
  }
}

abstract class OnRefreshListener {

  void refresh();
}