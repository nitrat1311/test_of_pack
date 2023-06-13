library slot_package;

import 'package:flutter/material.dart';
// import 'package:neon/neon.dart';

class AppColors {
  static const appLable = 'Championship Chance';
  static const myPackage = 'slot_package';
  static const glowingDuration = Duration(milliseconds: 4500);
  static const backColor = Color.fromRGBO(119, 0, 255, 1); //any colors
  static const frontColor = Color.fromRGBO(249, 237, 237, 1); //any colors
  static const buttonColor =
      Colors.lightGreen; //[Colors. red,pink,purple,deepPurple,
  //indigo,blue,lightBlue,cyan,teal,green,lightGreen,lime,yellow,amber,orange,deepOrange,brown,blueGrey]
  static const double randomPadding = 37.5; //20-40 limit
  static const textButtonMenu = Colors.black;
  static const borderRadius = BorderRadius.all(Radius.circular(1.9));
  // static const neonFont = NeonFont.LasEnter;
  static const pauseAlihnment = Alignment(-0.9, -.8);
  static const startAlihnment = Alignment(randomPadding / 45, 0.8);
  static const double scoreY = randomPadding * 10;
  static const double scoreX1 = (0.5);
  static const double scoreX2 = (100);
  static const buttonShape = ContinuousRectangleBorder(
      borderRadius: AppColors.borderRadius,
      side: BorderSide(
          width: randomPadding / 5, color: Color.fromARGB(255, 3, 3, 73)));
}
