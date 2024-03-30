import 'package:flutter/material.dart';

ThemeData appThemeData({BuildContext? context}) {
  return ThemeData(
    fontFamily: 'Vazirmatn',
    primaryColor: Colors.purple,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.amber,
      primary: Colors.purple,
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
    unselectedWidgetColor: Colors.grey[600],
  );
}
