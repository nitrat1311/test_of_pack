import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';

class GlowingButton extends StatefulWidget {
  final Widget child;

  const GlowingButton({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  GlowingButtonState createState() => GlowingButtonState();
}

class GlowingButtonState extends State<GlowingButton> {
  var glowing = false;
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.symmetric(vertical: AppColors.randomPadding / 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.buttonColor, width: 4),
        borderRadius: BorderRadius.circular(75),
        gradient: const LinearGradient(
          colors: [
            AppColors.frontColor,
            AppColors.backColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.solid,
            offset: const Offset(0, 7.0),
            blurRadius: 26,
            color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.3),
          ),
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(
                0, AppColors.randomPadding / 3, 0, AppColors.randomPadding / 2),
            child: widget.child),
      ]),
    );
  }
}
