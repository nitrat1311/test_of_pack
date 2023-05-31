import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';
import '../screens/records_table.dart';
import '../../widgets/glowing_button.dart';

import 'select.dart';
import 'settings_menu.dart';

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
    const double angle = 0.1;
    final Shader linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.gradientTitle2,
        AppColors.gradientTitle2,
      ],
    ).createShader(Rect.fromCenter(
        center: Offset(0, 90.h),
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 30));

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'packages/slot_package/assets/images/scaffold_back.png',
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
                    padding: REdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: AutoSizeText(
                      'BetBlitz Fortune',
                      wrapWords: false,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          foreground: Paint()
                            ..color = Colors.black
                            ..shader = linearGradient,
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                          shadows: [
                            Shadow(
                              offset: const Offset(3, 3.0),
                              blurRadius: 8,
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(1),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Transform.rotate(
                    angle: angle,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Select(),
                          ),
                        );
                      },
                      child: GlowingButton(
                        child: Text(
                          'game',
                          style: TextStyle(
                              color: AppColors.textButtonMenu, fontSize: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: angle,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RecordsTable(),
                          ),
                        );
                      },
                      child: GlowingButton(
                        child: Text(
                          'records',
                          style: TextStyle(
                              color: AppColors.textButtonMenu, fontSize: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: angle,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsMenu(),
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
