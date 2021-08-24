import 'dart:async';
import 'dart:ffi';

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
  bool isStartGame = false;


  void jump() {
    currentHeight = birdYPos;
    time = 0;
    if(!isStartGame){
      isStartGame = true;
      startGame();
    }
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
        isStartGame = false;
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: jump,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: AnimatedContainer(
                    alignment: Alignment(0,birdYPos),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: _MyBird(),
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
  const _MyBird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: 50, height: 50, child: FlutterLogo());
  }
}
