library slot_package;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slot_machine/slot_machine.dart';
import 'package:neon/neon.dart';
import '../const_colors.dart';
import 'game/game.dart';
import 'pause_menu.dart';

// This class represents the pause button overlay.
class PauseButton extends StatefulWidget {
  static const String id = 'PauseButton';
  final MasksweirdGame gameRef;

  const PauseButton({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<PauseButton> createState() => _PauseButtonState();
}

late SlotMachineController _controller;
bool isRunning = false;

void onButtonTap({required int index}) {
  _controller.stop(reelIndex: index);
}

onStart() {
  final index = Random().nextInt(20);
  _controller.start(hitRollItemIndex: index < 5 ? index : null);
  Future.delayed(const Duration(seconds: 1)).then((value) {
    _controller.stop(reelIndex: 0);
    _controller.stop(reelIndex: 1);
    _controller.stop(reelIndex: 2);
  });
}

class _PauseButtonState extends State<PauseButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Align(
        alignment: AppColors.pauseAlihnment,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.pink.withOpacity(0.5)),
            shadowColor:
                const MaterialStatePropertyAll<Color>(AppColors.backColor),
            elevation: MaterialStateProperty.all(15),
            shape: MaterialStateProperty.all(
              AppColors.buttonShape,
            ),
            side: MaterialStateProperty.all(
              const BorderSide(
                color: Colors.red,
                width: 10,
              ),
            ),
            //   backgroundColor: const MaterialStatePropertyAll<Color>(
            //       Color.fromARGB(255, 30, 14, 57)),
          ),
          child: SizedBox(
            height: 60.h,
            width: 80.w,
            child: Neon(
              text: 'X',
              color: AppColors.buttonColor,
              fontSize: 30.h,
              font: AppColors.neonFont,
            ),
          ),
          onPressed: () {
            widget.gameRef.pauseEngine();
            widget.gameRef.overlays.add(PauseMenu.id);
            widget.gameRef.overlays.remove(PauseButton.id);
          },
        ),
      ),
      Align(
        alignment: const Alignment(0.02, 0.0),
        child: SlotMachine(
          shuffle: true,
          multiplyNumberOfSlotItems: 4,
          width: MediaQuery.of(context).size.width / 1.3,
          reelSpacing: MediaQuery.of(context).size.width / 35.5,
          height: 100.h,
          reelWidth: 100.w,
          reelHeight: 220.h,
          reelItemExtent: 80.w,
          rollItems: [
            RollItem(
                index: 0,
                child: Image.asset(
                    'packages/${AppColors.myPackage}/assets/images/roll_item_1.png')),
            RollItem(
                index: 1,
                child: Image.asset(
                    'packages/${AppColors.myPackage}/assets/images/roll_item_2.png')),
            RollItem(
                index: 2,
                child: Image.asset(
                    'packages/${AppColors.myPackage}/assets/images/roll_item_3.png')),
            RollItem(
                index: 3,
                child: Image.asset(
                    'packages/${AppColors.myPackage}/assets/images/roll_item_4.png')),
            RollItem(
                index: 4,
                child: Image.asset(
                    'packages/${AppColors.myPackage}/assets/images/roll_item_5.png')),
            RollItem(
                index: 5,
                child: Image.asset(
                    'packages/${AppColors.myPackage}/assets/images/roll_item_6.png')),
          ],
          onCreated: (controller) {
            _controller = controller;
          },
          onFinished: (resultIndexes) {
            isRunning = false;
            if (resultIndexes[0] == resultIndexes[1] &&
                resultIndexes[2] == resultIndexes[1]) {
              widget.gameRef.player.addToScore(10);
            }
            if (resultIndexes[0] == resultIndexes[1] &&
                resultIndexes[2] == resultIndexes[1] &&
                resultIndexes[1] == 4) {
              widget.gameRef.player.addToScore(150);
            }
          },
        ),
      ),
      Align(
        alignment: AppColors.startAlihnment,
        child: ElevatedButton(
          style: ButtonStyle(
            shadowColor: const MaterialStatePropertyAll<Color>(Colors.black),
            elevation: MaterialStateProperty.all(15),
            shape: MaterialStateProperty.all(
              AppColors.buttonShape,
            ),
            side: MaterialStateProperty.all(
              const BorderSide(
                color: Colors.red,
                width: 8,
              ),
            ),
            backgroundColor: MaterialStatePropertyAll<Color>(
                AppColors.buttonColor.withOpacity(0.5)),
          ),
          onPressed: () {
            if (!isRunning) {
              setState(() {
                if (widget.gameRef.player.score == -50) {
                  widget.gameRef.player.increaseHealthBy(-100);
                }
                widget.gameRef.player.addToScore(-10);

                onStart();
                isRunning = true;
              });
            }
          },
          child: SizedBox(
            height: 60.h,
            width: 80.w,
            child: Neon(
              text: 'GO',
              color: AppColors.buttonColor,
              fontSize: 30.h,
              font: AppColors.neonFont,
            ),
          ),
        ),
      ),
    ]);
  }
}
