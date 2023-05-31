import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_state.dart';
import '../../const/colors.dart';
import 'game_menu.dart';

// This class represents the settings menu.
class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

var soundEffects = AppState().soundEffects;
var backgroundMusic = AppState().backgroundMusic;

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final Shader linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.gradientTitle1,
        AppColors.gradientTitle2,
      ],
    ).createShader(Rect.fromCenter(
        center: Offset(0, 45.h),
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
            height: MediaQuery.of(context).size.height / 1.9,
            width: MediaQuery.of(context).size.width / 1.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                          backgroundColor:
                              Color.fromARGB(255, 28, 21, 18).withOpacity(0.8),
                          foreground: Paint()
                            ..color = Colors.black
                            ..shader = linearGradient,
                          fontSize: 50.sp,
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1.0),
                              blurRadius: 2,
                              color: Colors.brown.withOpacity(1),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SwitchListTile(
                    activeColor: AppColors.gradientTitle2,
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(65.0),
                        border: Border.all(
                          color: AppColors.gradientTitle2,
                          width: 4.0,
                        ),
                        color: AppColors.gradientTitle1,
                      ),
                      child: Container(
                          padding: REdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: AutoSizeText(
                              'Sound',
                              maxLines: 1,
                              minFontSize: 9,
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  color: Colors.white,
                                  letterSpacing: 5.sp),
                            ),
                          )),
                    ),
                    value: soundEffects,
                    onChanged: (newValue) {
                      soundEffects = newValue;
                      AppState().soundEffects = newValue;
                      setState(() {});
                    },
                  ),

                  // Switch for background music.
                  SizedBox(height: 25.h),

                  SwitchListTile(
                    activeColor: AppColors.gradientTitle2,
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(65.0),
                        border: Border.all(
                          color: AppColors.gradientTitle2,
                          width: 4.0,
                        ),
                        color: AppColors.gradientTitle1,
                      ),
                      child: Container(
                        padding: REdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(65),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Music',
                            style: TextStyle(
                                fontSize: 25.sp,
                                color: Colors.white,
                                letterSpacing: 5.sp),
                          ),
                        ),
                      ),
                    ),
                    value: backgroundMusic,
                    onChanged: (newValue) {
                      backgroundMusic = newValue;
                      AppState().backgroundMusic = newValue;
                      setState(() {});
                    },
                  ),

                  SizedBox(height: 20.h),
                  // Back button.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border:
                          Border.all(color: AppColors.gradientTitle2, width: 4),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.gradientTitle1,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const GameMenu(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.gradientTitle2,
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
