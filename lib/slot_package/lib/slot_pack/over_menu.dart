library slot_package;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const_colors.dart';
import 'game/game.dart';
import 'game_menu.dart';
import 'pause_btn.dart';

// This class represents the game over menu overlay.
class OverMenu extends StatelessWidget {
  static const String id = 'GameOverMenu';
  final MasksweirdGame gameRef;

  const OverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pause menu title.
          Padding(
            padding: REdgeInsets.only(top: AppColors.randomPadding * 3),
            child: Stack(
              children: [
                Text(
                  'Game Over',
                  style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: 5.0,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = AppColors.frontColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Game Over',
                  style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: 5.0,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 1
                        ..color = AppColors.backColor,
                      // color: ,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),

          // Restart button.
          Container(
            padding: const EdgeInsets.only(left: AppColors.randomPadding - 30),
            decoration: BoxDecoration(
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: Colors.transparent, width: 4),
            ),
            child: FloatingActionButton.large(
              backgroundColor: AppColors.frontColor,
              shape: AppColors.buttonShape,
              onPressed: () {
                gameRef.overlays.remove(OverMenu.id);
                gameRef.overlays.add(PauseButton.id);
                gameRef.reset(context);
                gameRef.resumeEngine();
              },
              child: const Icon(
                Icons.restart_alt_rounded,
                color: AppColors.textButtonMenu,
              ),
            ),
          ),

          // Exit button.
          Container(
            decoration: BoxDecoration(
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: Colors.transparent, width: 4),
            ),
            margin: REdgeInsets.only(top: AppColors.randomPadding),
            child: FloatingActionButton.large(
              shape: AppColors.buttonShape,
              backgroundColor: AppColors.frontColor,
              elevation: 20,
              onPressed: () {
                gameRef.overlays.remove(OverMenu.id);
                gameRef.reset(context);
                gameRef.resumeEngine();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GameMenu(),
                  ),
                );
              },
              child: const Icon(
                Icons.exit_to_app,
                color: AppColors.textButtonMenu,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
