library slot_package;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const_colors.dart';
import 'game_play.dart';

class SelectCharacter extends StatelessWidget {
  const SelectCharacter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'packages/${AppColors.myPackage}/assets/images/show_case.png',
          width: 428.w,
          height: 926.h,
          fit: BoxFit.cover,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start button.
              Container(
                margin: REdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 1.1),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.backColor, width: 4),
                  borderRadius: AppColors.borderRadius,
                ),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppColors.frontColor,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const GamePlay(startPage: 0),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.circle,
                    color: AppColors.backColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
