library slot_package;

import 'package:flutter/rendering.dart';

import '../const_colors.dart';
import 'preload_image.dart';

Future<void> loadRes() async {
  await Future.wait([
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/roll_item_1.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/roll_item_2.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/roll_item_3.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/roll_item_4.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/roll_item_5.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/roll_item_6.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/game_back.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/show_case.png')),
    preloadImage(const AssetImage(
        'packages/${AppColors.myPackage}/assets/images/menu_back.png')),
  ]);
}
