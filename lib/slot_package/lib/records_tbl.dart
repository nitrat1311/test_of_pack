library slot_package;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slot_package/const_colors.dart';
import 'game_menu.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordsTbl extends StatelessWidget {
  static List records = [30, 80, 7, 200, 350];
  const RecordsTbl({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final Shader linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.frontColor,
        AppColors.backColor,
      ],
    ).createShader(Rect.fromCenter(
        center: Offset(0, 55.h),
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 30));

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
                  _buildRecordsList(),
                  SizedBox(height: 30.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border: Border.all(
                        color: AppColors.backColor,
                        width: 4,
                      ),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.frontColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GameMenu()));
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.backColor,
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

  Widget _buildRecordsList() {
    return SingleChildScrollView(
      child: SeparatedColumn(
        separator: SizedBox(height: 4.h),
        children: [
          for (var i = 0; i < records.length; i++)
            _RecordListItem(place: i + 1, record: records.elementAt(i)),
        ],
      ),
    );
  }
}

class _RecordListItem extends StatelessWidget {
  const _RecordListItem({
    Key? key,
    required this.place,
    required this.record,
  }) : super(key: key);

  final int place;
  final int record;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(65.0),
        border: Border.all(
          color: AppColors.backColor,
          width: 4.0,
        ),
        color: AppColors.frontColor,
      ),
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(65.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildPlaceText(),
                SizedBox(width: 12.w),
                _buildPlayerName(),
              ],
            ),
            _buildPlayerScore(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceText() {
    return Text(
      '$place.',
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 5.0,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayerName() {
    return Text(
      'Player',
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 5.0,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayerScore() {
    return Text(
      '$record',
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 5.0,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class SeparatedColumn extends StatelessWidget {
  const SeparatedColumn({
    Key? key,
    required this.separator,
    this.children = const <Widget>[],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.mainAxisSize = MainAxisSize.max,
    this.includeOuterTop = true,
    this.includeOuterBottom = true,
    this.includeOuterSeparators = false,
    this.textDirection,
    this.textBaseline,
  }) : super(key: key);

  final Widget separator;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final VerticalDirection verticalDirection;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool includeOuterTop;
  final bool includeOuterBottom;
  final bool includeOuterSeparators;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (this.children.isNotEmpty) {
      if (includeOuterSeparators && includeOuterTop) {
        children.add(separator);
      }

      for (int i = 0; i < this.children.length; i++) {
        children.add(this.children[i]);
        if (i != this.children.length - 1) {
          children.add(separator);
        }
      }

      if (includeOuterSeparators && includeOuterBottom) {
        children.add(separator);
      }
    }

    return Column(
      key: key,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }
}
