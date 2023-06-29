import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../game/game.dart';
import '../../screens/game_menu.dart';
import 'pause_button.dart';

// This class represents the pause menu overlay.
class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final MasksweirdGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          Padding(
            padding: REdgeInsets.symmetric(vertical: 70.0),
            child: Stack(children: [
              Text(
                'Paused',
                style: TextStyle(
                    fontSize: 40.sp,
                    letterSpacing: 15.0,
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..strokeWidth = 4
                      ..color = AppColors.backColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Paused',
                style: TextStyle(
                    fontSize: 40.sp,
                    letterSpacing: 15.0,
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..strokeWidth = 1
                      ..color = AppColors.frontColor,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),

          // Resume button.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.buttonColor, width: 4),
                  borderRadius: AppColors.borderRadius,
                ),
                child: FloatingActionButton.large(
                  backgroundColor: AppColors.backColor,
                  onPressed: () {
                    gameRef.resumeEngine();
                    gameRef.overlays.remove(PauseMenu.id);
                    gameRef.overlays.add(PauseButton.id);
                  },
                  child: const Icon(
                    Icons.start,
                    color: AppColors.frontColor,
                  ),
                ),
              ),

              // Restart button.
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.buttonColor, width: 4),
                  borderRadius: AppColors.borderRadius,
                ),
                child: FloatingActionButton.large(
                  backgroundColor: AppColors.backColor,
                  onPressed: () {
                    gameRef.overlays.remove(PauseMenu.id);
                    gameRef.overlays.add(PauseButton.id);
                    gameRef.reset();
                    gameRef.resumeEngine();
                  },
                  child: const Icon(
                    Icons.restart_alt,
                    color: AppColors.frontColor,
                  ),
                ),
              ),
            ],
          ),

          // Exit button.
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonColor, width: 4),
              borderRadius: AppColors.borderRadius,
            ),
            margin: REdgeInsets.only(top: 10),
            child: FloatingActionButton.large(
              backgroundColor: AppColors.backColor,
              elevation: 20,
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.reset();
                gameRef.resumeEngine();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GameMenu(),
                  ),
                );
              },
              child: const Icon(
                Icons.leave_bags_at_home,
                color: AppColors.frontColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
