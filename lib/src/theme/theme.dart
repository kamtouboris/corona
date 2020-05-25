import 'package:flutter/material.dart';

final myTheme = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Color(0xFFF8F8FF),
  fontFamily: 'Sen',
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Color(0xFF7777FF),
    ),
    headline2: TextStyle(
      color: Colors.black,
    ),
    subtitle1: TextStyle(
      color: Color(0xFF707070),
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF7777FF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    minWidth: 100,
    height: 40,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);