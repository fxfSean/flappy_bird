import 'dart:async';
import 'dart:ffi';

import 'package:flappy_bird/barrier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _HomePage());
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  double birdYPos = 0;
  double currentHeight = 0;
  double time = 0;
  double height = 0;
  bool gameStarted = false;


  void jump() {
    currentHeight = birdYPos;
    time = 0;
  }

  void startGame() {
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYPos = currentHeight - height;
      });
      if(birdYPos > 0.8){
        timer.cancel();
        time = 0;
        birdYPos = 0;
        gameStarted = false;
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
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
                      _MyBird(birdY: birdYPos,),
                      AnimatedContainer(
                        alignment: Alignment(0,1),
                        duration: Duration(milliseconds: 0),
                          child: MyBarrier()),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.green,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MyBird extends StatelessWidget {

  const _MyBird({Key? key, this.birdY}) : super(key: key);

  final birdY;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment(0,birdY),
      duration: Duration(milliseconds: 0),
      color: Colors.blue,
      child: FlutterLogo(),
    );
  }
}
