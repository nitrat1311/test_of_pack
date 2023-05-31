import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';

class RecordsTable extends StatelessWidget {
  const RecordsTable({
    Key? key,
  }) : super(key: key);

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
        center: Offset(0, 55.h),
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
                    padding: REdgeInsets.symmetric(vertical: 35.0),
                    child: Text(
                      'Scores',
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
                  Center(child: Text('No Scores now')),
                  SizedBox(height: 30.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border: Border.all(
                        color: AppColors.gradientTitle2,
                        width: 4,
                      ),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.gradientTitle1,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GameMenu()));
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.gradientTitle2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
