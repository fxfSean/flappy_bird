
import 'package:flappy_bird/component/component.dart';
import 'package:flutter/cupertino.dart';

class LandArea{
  Animation<Offset>? _animation;
  Animation<Offset>? _animation2;
  AnimationController? _animationController;

  final TickerProviderStateMixin _tickerProviderStateMixin;

  LandArea(this._tickerProviderStateMixin){
    init();
  }



  void init() {
    _animationController = AnimationController(duration: Duration(milliseconds: 3500),
        vsync: _tickerProviderStateMixin);
    _animation = Tween(begin: Offset.zero,end: Offset(-1,0)).animate(_animationController!);
    _animation2 = Tween(begin: Offset(1,0),end: Offset.zero).animate(_animationController!);
    _animationController!.repeat(reverse: false);

  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _animation!,
          child: ClipRect(
            clipper: _MyClipper(),
            child: Image(
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              image: AssetImage('assets/images/land.png'),
            ),
          ),
        ),
        SlideTransition(
          position: _animation2!,
          child: ClipRect(
            clipper: _MyClipper(),
            child: Image(
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              image: AssetImage('assets/images/land.png'),
            ),
          ),
        ),
      ],
    );
  }

  void gameOver() {
    _animationController!.stop();
  }

  void gameStart() {
    _animationController!.repeat(reverse: false);
  }
}

class _MyClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(0, 0, size.width,  size.height- size.height/2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}