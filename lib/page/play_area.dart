
import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/strategy/game_engine.dart';
import 'package:flappy_bird/strategy/score_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/barrier.dart';
import '../component/bird.dart';
import '../constants/constants.dart';
import '../strategy/hit_strategy.dart';
import '../component/land.dart';

class PlayArea extends StatefulWidget {
  const PlayArea({Key? key}) : super(key: key);

  @override
  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> with TickerProviderStateMixin,
      OnRefreshListener{
  GameEngine _gameEngine = GameEngine();


  @override
  void initState() {
    _gameEngine.init(this,this);

    super.initState();
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
            Image(image: AssetImage('assets/images/bird.png'),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: (){
                  _gameEngine.replay(false);
                }, child: Text('取消'),),
                ElevatedButton(onPressed: (){
                  _gameEngine.replay(true);
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
              onTap: _gameEngine.onUserTab,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            _gameEngine.myBird.build(),
                            ..._gameEngine.myBarrier.barrierBuilder(context),
                            Container(
                              alignment: Alignment(0,-0.5),
                              child: Text( _gameEngine.gameStarted
                                  ? '${scoreCounter.score}'
                                  : 'TAP TO START',style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white
                              ),),
                            )
                          ],
                        ),
                      ),
                      _buildScoreContent(context)
                    ],
                  ),
                ],
              ),
            ),
            if(_gameEngine.gameOver)
              _gameOverDialog(),
          ]
      ),
    );
  }

  Expanded _buildScoreContent(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              RepaintBoundary(
                child: _gameEngine.landArea.build(context),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'SCORE',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${scoreCounter.score}',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'BEST',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${scoreCounter.maxScore}',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void refresh() {
    setState(() {
    });
  }
}
