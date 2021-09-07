
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double size;
  const MyBarrier({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
          border: Border.all(
          width: 10,
          color: Colors.green),
        borderRadius: BorderRadius.circular(15)
      ),
      width: 100,
      height: size,
    );
  }
}

class BarrierHeightStrategy {

  static double generateRandomHeight(){
    return 50 + Random().nextInt(250).toDouble();
  }
}