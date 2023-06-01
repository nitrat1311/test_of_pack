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
                          backgroundColor: AppColors.backColor.withOpacity(0.8),
                          foreground: Paint()..color = AppColors.frontColor,
                          fontSize: 50.sp,
                          shadows: const [
                            Shadow(
                                offset: Offset(1, 1.0),
                                blurRadius: 2,
                                color: AppColors.backColor),
                          ]),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SwitchListTile(
                    activeColor: AppColors.frontColor,
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(65.0),
                        border: Border.all(
                          color: AppColors.buttonColor,
                          width: 4.0,
                        ),
                        color: AppColors.backColor,
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
                    activeColor: AppColors.frontColor,
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(65.0),
                        border: Border.all(
                          color: AppColors.buttonColor,
                          width: 4.0,
                        ),
                        color: AppColors.backColor,
                      ),
                      child: Container(
                        padding: REdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: AppColors.borderRadius,
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
                      border: Border.all(color: AppColors.frontColor, width: 4),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.backColor,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const GameMenu(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.frontColor,
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
