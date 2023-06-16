library slot_package;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const_colors.dart';
import 'game/game.dart';
import 'game_menu.dart';
import 'pause_btn.dart';

// This class represents the pause menu overlay.
class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final MasksweirdGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pause menu title.
            Padding(
              padding: REdgeInsets.only(top: AppColors.randomPadding * 3),
              child: Stack(children: [
                Text(
                  'Paused',
                  style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: 7.0,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = AppColors.frontColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Paused',
                  style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: 7.0,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 1
                        ..color = Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),

            // SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: AppColors.randomPadding - 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 4),
                    borderRadius: AppColors.borderRadius,
                  ),
                  child: FloatingActionButton.large(
                    shape: AppColors.buttonShape,
                    backgroundColor: AppColors.frontColor,
                    onPressed: () {
                      gameRef.resumeEngine();
                      gameRef.overlays.remove(PauseMenu.id);
                      gameRef.overlays.add(PauseButton.id);
                    },
                    child: const Icon(
                      Icons.play_arrow_sharp,
                      color: AppColors.textButtonMenu,
                    ),
                  ),
                ),
                // SizedBox(height: 20.h),
                Container(
                  padding:
                      const EdgeInsets.only(top: AppColors.randomPadding - 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 4),
                    borderRadius: AppColors.borderRadius,
                  ),
                  child: FloatingActionButton.large(
                    backgroundColor: AppColors.frontColor,
                    shape: AppColors.buttonShape,
                    onPressed: () {
                      gameRef.overlays.remove(PauseMenu.id);
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
              ],
            ),
            // SizedBox(height: 20.h),
            Container(
              margin:
                  const EdgeInsets.only(right: AppColors.randomPadding - 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 4),
                borderRadius: AppColors.borderRadius,
              ),
              // margin: REdgeInsets.only(top: 10),
              child: FloatingActionButton.large(
                backgroundColor: AppColors.frontColor,
                shape: AppColors.buttonShape,
                elevation: 20,
                onPressed: () {
                  gameRef.overlays.remove(PauseMenu.id);
                  gameRef.reset(context);
                  gameRef.resumeEngine();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GameMenu(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.exit_to_app_sharp,
                  color: AppColors.textButtonMenu,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
