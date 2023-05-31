import 'package:flutter/material.dart';
// import 'package:test_of_pack/slot_package/lib/slot_pack/game_menu.dart';
import 'package:slot_package/slot_pack/game_menu.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
      ),
    ),
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Jost',
      scaffoldBackgroundColor: Colors.black,
    ),
    home: const GameMenu(),
  ));
}
