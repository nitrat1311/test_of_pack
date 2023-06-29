import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slot_package/widgets/glowing_button.dart';

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
        Container(color: Colors.black,),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width / 1.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: REdgeInsets.symmetric(vertical: 35.0),
                    child: AutoSizeText(
                      'Team 1 vs Team 2',
                      maxLines: 1,
                      style: TextStyle(

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
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlowingButton(child: AutoSizeText('INFORMATION',style: TextStyle(fontSize: 32,color: Colors.white),textAlign: TextAlign.start)),
                      SizedBox(
                        height: 25
                      ),
                  
                      GlowingButton(child: Text('Goals     >',style: AppColors.style,textAlign: TextAlign.start,),),
                      GlowingButton(child: Text('Results   >',style: AppColors.style,textAlign: TextAlign.start),),
                      GlowingButton(child: Text('Total     >',style: AppColors.style,textAlign: TextAlign.start),),
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
                    child: ElevatedButton(
          style:  ButtonStyle( backgroundColor:ButtonStyleButton.allOrNull(Colors.amber)),
                     
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GameMenu()));
                      },
                      child: const Text('GO BACK',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),)
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
