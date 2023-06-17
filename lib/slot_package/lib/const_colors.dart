library slot_package;

import 'package:flutter/material.dart';
import 'package:neon/neon.dart';

class AppColors {
  static const appLable = 'Вайт приложение 1';
  static const myPackage = 'slot_package';
  static const glowingDuration = Duration(milliseconds: 4500);
  static const backColor = Color.fromRGBO(182, 0, 0, 1); //any colors
  static const frontColor = Color.fromRGBO(174, 128, 53, 1); //any colors
  static const buttonColor = Colors.red; //[Colors. red,pink,purple,deepPurple,
  //indigo,blue,lightBlue,cyan,teal,green,lightGreen,lime,yellow,amber,orange,deepOrange,brown,blueGrey]
  static const double randomPadding = 29.5; //20-40 limit
  static const textButtonMenu = Colors.black;
  static const borderRadius = BorderRadius.all(
      Radius.elliptical(randomPadding * 1.9, randomPadding - 10));
  static const neonFont = NeonFont.Automania;
  static const pauseAlihnment = Alignment(-randomPadding / 45, -.3);
  static const startAlihnment = Alignment(randomPadding / 45, -0.3);
  static const double scoreY = randomPadding * 15;
  static const double scoreX1 = (0.4);
  static const double scoreX2 = (100);
  static const buttonShape = ContinuousRectangleBorder(
      borderRadius: AppColors.borderRadius,
      side: BorderSide(width: randomPadding / 5, color: Colors.white));
}
