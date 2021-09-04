import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/barrier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

GlobalKey _keyBird = GlobalKey();

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
  static double barrierXOnePos = 2;
  double barrierXTwoPos = barrierXOnePos + 1.8;
  double barrierHeightOne = 200;
  double barrierHeightTwo = 150;
  double currentHeight = 0;
  double time = 0;
  double height = 0;
  bool gameStarted = false;
  bool gameOver = false;
  double downVelocity = 0;
  double maxDownVelocity = 2;
  List<GlobalKey> listKeys = [];

  @override
  void initState() {
    for(var i=0; i<2; i++){
      listKeys.add(GlobalKey());
    }
    super.initState();
  }


  void jump() {
    currentHeight = birdYPos;
    time = 0;
  }

  void startGame() {
    print('宽度${MediaQuery.of(context).size.width}');
    print('高度${MediaQuery.of(context).size.height}');

    currentHeight = birdYPos;
    Timer.periodic(Duration(milliseconds: 15), (timer) {
      final RenderBox renderObjBird =
          _keyBird.currentContext?.findRenderObject() as RenderBox;
      final position = renderObjBird.localToGlobal(Offset.zero);
      // print('鸟大小宽：${renderObjBird.size} 位置：$position');
      listKeys.forEach((element) {
        final RenderBox renderObjBird =
        element.currentContext?.findRenderObject() as RenderBox;
        final position = renderObjBird.localToGlobal(Offset.zero);
        print('块大小宽：${renderObjBird.size} 位置：$position');
      });
      time += 0.0125;
      downVelocity = -4.9 * time;
      downVelocity = min(downVelocity, maxDownVelocity);
      height = downVelocity * time + 2.7 * time;
      setState(() {
        birdYPos = currentHeight - height;

        if(barrierXOnePos < -2){
          barrierXOnePos += 3.7;
          barrierHeightOne = BarrierHeightStrategy.generateRandomHeight();
        } else {
          barrierXOnePos -= 0.0125;
        }
        if(barrierXTwoPos < -2){
          barrierXTwoPos += 3.7;
          barrierHeightTwo = BarrierHeightStrategy.generateRandomHeight();
          print('高度：$barrierHeightTwo');
        } else {
          barrierXTwoPos -= 0.0125;
        }
      });
      if(birdYPos > 1){
        timer.cancel();
        gameOver = true;
        time = 0;
        gameStarted = false;
        setState(() {
        });
      }
    });
  }

  void _replay(){
    _resetGame();
  }

  void _resetGame(){
    birdYPos = 0;
    barrierXOnePos = 1;
    barrierXTwoPos = barrierXOnePos + 1.8;
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
                  _resetGame();
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
                          _MyBird(birdY: birdYPos,),
                          AnimatedContainer(
                              alignment: Alignment(barrierXOnePos,1.1),
                              duration: Duration(milliseconds: 0),
                              child: MyBarrier(
                                key: listKeys[0],
                                size: barrierHeightOne,
                              )),
                          AnimatedContainer(
                              alignment: Alignment(barrierXOnePos,-1),
                              duration: Duration(milliseconds: 0),
                              child: MyBarrier(
                                size: 400 - barrierHeightOne,
                              )),

                          AnimatedContainer(
                              alignment: Alignment(barrierXTwoPos,1.1),
                              duration: Duration(milliseconds: 0),
                              child: MyBarrier(
                                key: listKeys[1],
                                size: barrierHeightTwo,
                              )),
                          AnimatedContainer(
                              alignment: Alignment(barrierXTwoPos,-1),
                              duration: Duration(milliseconds: 0),
                              child: MyBarrier(
                                size: 400 - barrierHeightTwo,
                              )),
                          Container(
                            alignment: Alignment(0,-0.3),
                            child: gameStarted
                                ? Text('')
                                : Text('TAP TO START',style: TextStyle(
                              fontSize: 20,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('SCORE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text('0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('BEST',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text('0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35
                                    ),
                                  )
                                ],
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

class _MyBird extends StatelessWidget {

  const _MyBird({Key? key, this.birdY}) : super(key: key);

  final birdY;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment(0,birdY),
      duration: Duration(milliseconds: 0),
      color: Colors.blue,
      child: FlutterLogo(key: _keyBird,),
    );
  }
}
