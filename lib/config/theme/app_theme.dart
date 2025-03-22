import 'package:flutter/material.dart';

class AppTheme {

  ThemeData getTheme() {
    const seedColor = Colors.lightBlue;
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      // listTileTheme: const ListTileThemeData(
      //   iconColor: seedColor
      // )
      appBarTheme: AppBarTheme(
        backgroundColor: seedColor,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }

}