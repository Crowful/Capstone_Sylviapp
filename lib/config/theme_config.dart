import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    backgroundColor: AppColor.bodyColor,
    scaffoldBackgroundColor: AppColor.bodyColor,
    hintColor: AppColor.textColor,
    primaryColorLight: AppColor.buttonBackgroundColor,
    textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold)),
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.black));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: AppColor.bodyColorDark,
    scaffoldBackgroundColor: AppColor.bodyColorDark,
    hintColor: AppColor.textColor,
    primaryColorLight: AppColor.buttonBackgroundColorDark,
    textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.white));
