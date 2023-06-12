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
                              AppColors.buttonColor.withOpacity(0.5),
                          foreground: Paint()..color = AppColors.frontColor,
                          fontSize: 50.sp,
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 1.0),
                              blurRadius: 2,
                              color: AppColors.backColor,
                            ),
                          ]),
                    ),
                  ),
                  Column(
                    children: [
                      Text('Score 1 : 350'),
                      Text('Score 2 : 250'),
                      Text('Score 2 : 150'),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border: Border.all(
                        color: AppColors.frontColor,
                        width: 4,
                      ),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.buttonColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GameMenu()));
                      },
                      child: const Icon(
                        Icons.holiday_village,
                        color: AppColors.frontColor,
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
