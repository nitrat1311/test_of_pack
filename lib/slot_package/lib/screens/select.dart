import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import 'game_play.dart';

class Select extends StatelessWidget {
  const Select({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'packages/slot_package/assets/images/ship_A.png',
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
                  border: Border.all(color: AppColors.gradientTitle2, width: 4),
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(5, 60)),
                ),
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppColors.gradientTitle1,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const GamePlay(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.circle,
                    color: AppColors.gradientTitle2,
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
