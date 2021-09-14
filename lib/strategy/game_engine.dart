
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
  bool gameStarted = false;
  bool gameOver = false;

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
      myBird.updateHeight(time);
      myBarrier.updateBarrierPos();
      if(_hitStrategy.hitGround()){
        timer.cancel();
        _gameOver();
      } else {
        _refreshListener.refresh();
      }
    });
  }

  void _gameOver(){
    gameOver = true;
    time = 0;
    gameStarted = false;
    landArea.gameOver();
    scoreCounter.calculateMax();
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
    scoreCounter.reset();
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