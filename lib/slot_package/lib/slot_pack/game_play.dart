library slot_package;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';

import 'settings_menu.dart';
import 'widgets/overlays/game_over_menu.dart';
import 'widgets/overlays/pause_button.dart';
import 'widgets/overlays/pause_menu.dart';

// Creating this as a file private object so as to
// avoid unwanted rebuilds of the whole game object.
// MasksweirdGame _masksweirdGame =
//     MasksweirdGame(recordsBloc: context.recordsBloc);

// This class represents the actual game screen
// where all the action happens.
class GamePlay extends StatelessWidget {
  final int startPage;
  const GamePlay({Key? key, required this.startPage}) : super(key: key);

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
          game: MasksweirdGame(),
          // Initially only pause button overlay will be visible.
          initialActiveOverlays:
              startPage == 0 ? [PauseButton.id] : [SettingsMenu.id],
          overlayBuilderMap: {
            PauseButton.id: (BuildContext context, MasksweirdGame gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.id: (BuildContext context, MasksweirdGame gameRef) =>
                PauseMenu(
                  gameRef: gameRef,
                ),
            GameOverMenu.id: (BuildContext context, MasksweirdGame gameRef) =>
                GameOverMenu(
                  gameRef: gameRef,
                ),
            SettingsMenu.id: (BuildContext context, MasksweirdGame gameRef) =>
                SettingsMenu(
                  gameRef: gameRef,
                ),
          },
        ),
      ),
    );
  }
}
