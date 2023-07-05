
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slot_package/screens/game_play.dart';

import 'package:flutter/material.dart' hide Route;


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


    return const GamePlay();
  }
}
