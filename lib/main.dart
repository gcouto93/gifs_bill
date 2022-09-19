import 'package:flutter/material.dart';
import 'package:gifs_bill/ui/gif_page.dart';
import 'package:gifs_bill/ui/home_page.dart';

void main() {
  runApp( MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData( cursorColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.white),
      )
    ),
  ));
}
