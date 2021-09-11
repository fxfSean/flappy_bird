
import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/score_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'barrier.dart';
import 'bird.dart';
import 'hit_strategy.dart';
import 'land.dart';

class PlayArea extends StatefulWidget {
  const PlayArea({Key? key}) : super(key: key);

  @override
  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> with TickerProviderStateMixin {

  double time = 0;
  double height = 0;
  bool gameStarted = false;
  bool gameOver = false;
  double downVelocity = 0;
  double maxDownVelocity = 2;
  int score = 0;
  int maxScore = 0;
  bool isRecorded = false;

  late LandArea _landArea;
  late MyBarrier _myBarrier;
  late HitStrategy _hitStrategy;
  late MyBird _myBird;

  @override
  void initState() {
    _landArea = LandArea(this);
    _myBarrier = MyBarrier();
    _myBird = MyBird();
    _hitStrategy = HitStrategy(_myBarrier,_myBird);
    scoreCounter.isRecordedController.stream.listen((event) {
      if (event) {
        score++;
      }
    });
    super.initState();
  }


  void jump() {
    _myBird.jump();
    time = 0;
  }

  void startGame() {
    _myBird.startGame();
    Timer.periodic(Duration(milliseconds: 15), (timer) {
      if(_hitStrategy.hitTest()){
        timer.cancel();
        _gameOver();
        return;
      }

      time += 0.0125;
      downVelocity = -4.9 * time;
      downVelocity = min(downVelocity, maxDownVelocity);
      height = downVelocity * time + 2.7 * time;
      setState(() {
        _myBird.updateHeight(height);
      });
      _myBarrier.updateBarrierPos();
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
    _landArea.gameOver();
    maxScore = max(maxScore, score);
    setState(() {
    });
  }

  void _replay(){
    _resetGame();
  }

  void _resetGame(){
    score = 0;
    isRecorded = false;
    _landArea.gameStart();
    _myBarrier.resetGame();
    _myBird.resetGame();
    setState(() {
      gameOver = false;
    });
  }

  Widget _gameOverDialog(){
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10,),
            FlutterLogo(size: 40,),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: (){
                  setState(() {
                    gameOver = false;
                  });
                }, child: Text('取消'),),
                ElevatedButton(onPressed: (){
                  _replay();
                }, child: Text('重试'))
              ],)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (gameOver) {
                  return;
                }
                if(!gameStarted){
                  gameStarted = true;
                  startGame();
                } else {
                  jump();
                }
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            _myBird.build(),
                            ..._myBarrier.barrierBuilder(context),
                            Container(
                              alignment: Alignment(0,-0.5),
                              child: Text( gameStarted
                                  ? '$score'
                                  : 'TAP TO START',style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white
                              ),),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey,
                            child: Column(
                              children: [
                                RepaintBoundary(
                                  child: _landArea.build(context),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('SCORE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Text('$score',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('BEST',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Text('$maxScore',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 35
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            if(gameOver)
              _gameOverDialog(),
          ]
      ),
    );
  }
}
