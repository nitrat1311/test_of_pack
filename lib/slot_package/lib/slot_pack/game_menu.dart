library slot_package;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flame/flame.dart';
import 'package:neon/neon.dart';

import '../const_colors.dart';
import 'game_play.dart';
import 'records_tbl.dart';
import 'resources_preloader.dart';
import 'select_spaceship.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.ensureScreenSize();
    Flame.device.fullScreen();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    loadRes();
    ScreenUtil.init(
      context,
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
    );
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'packages/${AppColors.myPackage}/assets/images/menu_back.png',
          width: 428.w,
          height: 926.h,
          fit: BoxFit.cover,
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
            width: MediaQuery.of(context).size.width / 1.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        REdgeInsets.fromLTRB(0, AppColors.randomPadding, 0, 0),
                    child: AutoSizeText(
                      AppColors.appLable,
                      wrapWords: false,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          backgroundColor: Colors.amber.withOpacity(0.5),
                          foreground: Paint()..color = Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, -2.0),
                              blurRadius: 8,
                              color: Colors.white,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: AppColors.randomPadding * 2.2.h),
                  Padding(
                    padding: REdgeInsets.only(left: AppColors.randomPadding),
                    child: GestureDetector(
                      child: Neon(
                        text: 'New Game',
                        color: AppColors.buttonColor,
                        fontSize: 40.h,
                        font: AppColors.neonFont,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SelectCharacter(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppColors.randomPadding.h),
                  Padding(
                    padding:
                        REdgeInsets.only(right: AppColors.randomPadding - 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RecordsTbl(),
                          ),
                        );
                      },
                      child: Neon(
                        text: 'Score',
                        color: AppColors.buttonColor,
                        fontSize: 40.h,
                        font: AppColors.neonFont,
                        glowingDuration: AppColors.glowingDuration,
                      ),
                    ),
                  ),
                  SizedBox(height: AppColors.randomPadding.h),
                  Padding(
                    padding:
                        REdgeInsets.only(right: AppColors.randomPadding + 30),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GamePlay(startPage: 1),
                          ),
                        );
                      },
                      child: Neon(
                        text: 'Settings',
                        color: AppColors.buttonColor,
                        fontSize: 40.h,
                        font: AppColors.neonFont,
                        glowingDuration: AppColors.glowingDuration,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h)
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
