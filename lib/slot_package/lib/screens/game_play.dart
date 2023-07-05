import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:slot_package/game/game2.dart';



class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WillPopScope provides us a way to decide if
      // this widget should be poped or not when user
      // presses the back button.
      body: WillPopScope(
        onWillPop: () async => false,
        // GameWidget is useful to inject the underlying
        // widget of any class extending from Flame's Game class.
        child: GameWidget(
          // game: MasksweirdGame(),
          game: RouterGame(),
       
        ),
      ),
    );
  }
}
