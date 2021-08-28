
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  const MyBarrier({Key? key}) : super(key: key);

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
      height: 200,
    );
  }
}
