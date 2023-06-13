library slot_package;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slot_package/const_colors.dart';

import 'game/audio_player_component.dart';
import 'game_menu.dart';
import 'game/game.dart';

// This class represents the settings menu.
class SettingsMenu extends StatefulWidget {
  static const String id = 'SettingsMenu';
  final MasksweirdGame gameRef;
  const SettingsMenu({Key? key, required this.gameRef}) : super(key: key);
  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var audio = AudioPlayerComponent();
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
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppColors.randomPadding),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                          backgroundColor: const Color.fromARGB(255, 28, 21, 18)
                              .withOpacity(0.8),
                          foreground: Paint()..color = AppColors.buttonColor,
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

                  // Switch for background music.
                  SizedBox(height: 25.h),

                  SwitchListTile(
                    activeColor: AppColors.buttonColor,
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: AppColors.borderRadius,
                        border: Border.all(
                          color: AppColors.backColor,
                          width: 4.0,
                        ),
                        color: AppColors.frontColor,
                      ),
                      child: Container(
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
                    value: value,
                    onChanged: (newValue) {
                      setState(() {
                        if (value) {
                          audio.playBgm('assets/audio/music.mp3');
                        }
                        audio.stopBgm();
                        value = newValue;
                      });
                    },
                  ),

                  SizedBox(height: 20.h),
                  // Back button.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border: Border.all(color: AppColors.backColor, width: 4),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.frontColor,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const GameMenu(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.backColor,
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
