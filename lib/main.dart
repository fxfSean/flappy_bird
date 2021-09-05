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
  static double initBarrierXPos = 2;
  static double barrierXOnePos = initBarrierXPos;
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
  GlobalKey _keyContainer = GlobalKey();

  @override
  void initState() {
    for(var i=0; i<4; i++){
      listKeys.add(GlobalKey());
    }
    super.initState();
  }


  void jump() {
    currentHeight = birdYPos;
    time = 0;
  }

  void startGame() {

    currentHeight = birdYPos;
    Timer.periodic(Duration(milliseconds: 15), (timer) {
      if(hitBarriers()){
        timer.cancel();
        _gameOver();
        return;
      }

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
        _gameOver();
      }
    });
  }

  bool hitBarriers(){
    final RenderBox birdRenderBox =
    _keyBird.currentContext?.findRenderObject() as RenderBox;
    final birdPos = birdRenderBox.localToGlobal(Offset.zero);
    print('鸟位置：${birdPos.dx} : ${birdPos.dy.roundToDouble()}');

    final RenderBox renderBoxFirstUpper =
    listKeys[0].currentContext?.findRenderObject() as RenderBox;
    final barrierFirstPos = renderBoxFirstUpper.localToGlobal(Offset.zero);

    final RenderBox renderBoxSecondUpper =
    listKeys[1].currentContext?.findRenderObject() as RenderBox;
    final barrierSecondPos = renderBoxSecondUpper.localToGlobal(Offset.zero);

    final RenderBox renderBoxContainer =
    _keyContainer.currentContext?.findRenderObject() as RenderBox;
    final container = renderBoxContainer.localToGlobal(Offset.zero);
    print('1036: ${renderBoxContainer.size} : ${container.dy}');

    print('1035 ${birdPos.dy} : ${barrierFirstPos.dy + renderBoxFirstUpper.size.height} : container: ${renderBoxContainer.size}');
    if(birdPos.dx + birdRenderBox.size.width > barrierFirstPos.dx){
      if(birdPos.dy > barrierFirstPos.dy || birdPos.dy < barrierFirstPos.dy - 200){
        print('1034 ${birdPos.dy} : ${barrierFirstPos.dy}');
        return true;
      }
    }
    if(birdPos.dx < barrierFirstPos.dx) {
      /// 没经过第一个barrier，返回
      return false;
    }

    // final RenderBox renderBoxSecondUpper =
    // listKeys[1].currentContext?.findRenderObject() as RenderBox;
    // final barrierSecondPos = renderBoxSecondUpper.localToGlobal(Offset.zero);
    if(birdPos.dx + birdRenderBox.size.width > barrierSecondPos.dx
        && birdPos.dy < barrierSecondPos.dy
    ){
      return true;
    }
    return false;
  }

  void _gameOver(){
    gameOver = true;
    time = 0;
    gameStarted = false;
    setState(() {
    });
  }

  void _replay(){
    _resetGame();
  }

  void _resetGame(){
    birdYPos = 0;
    barrierXOnePos = initBarrierXPos;
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
                      key: _keyContainer,
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
                              key: listKeys[1],
                              alignment: Alignment(barrierXOnePos,-1),
                              duration: Duration(milliseconds: 0),
                              child: MyBarrier(
                                size: 400 - barrierHeightOne,
                              )),

                          AnimatedContainer(
                              key: listKeys[2],
                              alignment: Alignment(barrierXTwoPos,1.1),
                              duration: Duration(milliseconds: 0),
                              child: MyBarrier(
                                size: barrierHeightTwo,
                              )),
                          AnimatedContainer(
                              key: listKeys[3],
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
