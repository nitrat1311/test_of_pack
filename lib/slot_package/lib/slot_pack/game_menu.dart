library slot_package;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flame/flame.dart';

import '../const_colors.dart';
import 'game_play.dart';
import 'records_tbl.dart';

import 'select_spaceship.dart';
import 'widgets/glowing_button.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.ensureScreenSize();
    Flame.device.fullScreen();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
        SizedBox(
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
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        background: Paint()
                          ..color = AppColors.buttonColor.withOpacity(0.3),
                        foreground: Paint()..color = AppColors.frontColor,
                        fontSize: 50,
                        fontWeight: FontWeight.normal,
                        shadows: const [
                          Shadow(
                            offset: Offset(3, 3.0),
                            blurRadius: 8,
                            color: AppColors.backColor,
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: AppColors.randomPadding + 20.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SelectCharacter(),
                        ),
                      );
                    },
                    child: GlowingButton(
                      child: Text(
                        'start game',
                        style: TextStyle(
                            color: AppColors.textButtonMenu, fontSize: 30.sp),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GamePlay(startPage: 1),
                        ),
                      );
                    },
                    child: GlowingButton(
                      child: Text(
                        'settings',
                        style: TextStyle(
                            color: AppColors.textButtonMenu, fontSize: 30.sp),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment:
                      const Alignment(AppColors.randomPadding / 100, -0.8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RecordsTbl(),
                        ),
                      );
                    },
                    child: GlowingButton(
                      child: Text(
                        'my records',
                        style: TextStyle(
                            color: AppColors.textButtonMenu, fontSize: 30.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
