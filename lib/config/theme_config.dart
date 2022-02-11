import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData light = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.light,
    backgroundColor: AppColor.bodyColor,
    dialogBackgroundColor: AppColor.dialogColor,
    scaffoldBackgroundColor: Colors.white,
    hintColor: AppColor.textColor,
    primaryColorLight: AppColor.buttonBackgroundColor,
    cardColor: Colors.white,
    textTheme: TextTheme(
        headline2: TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
        headline1: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        headline5: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
        headline6: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15)),
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.black));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: AppColor.bodyColorDark,
    scaffoldBackgroundColor: AppColor.bodyColorDark,
    dialogBackgroundColor: AppColor.dialogColorDark,
    cardColor: AppColor.dialogColorDark,
    hintColor: AppColor.textColor,
    primaryColorLight: AppColor.buttonBackgroundColorDark,
    textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        headline2: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
        headline5: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
        headline6: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15)),
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.white));
