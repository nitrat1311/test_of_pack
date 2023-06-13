import 'package:flutter/material.dart';
import 'package:slot_package/game_menu.dart';

// import 'package:slot_package/screens/game_menu.dart';

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
