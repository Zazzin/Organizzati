import 'package:flutter/material.dart';


class SettingsController extends ChangeNotifier {
 ThemeMode _themeMode = ThemeMode.light;


 ThemeMode get themeMode => _themeMode;


 void updateThemeMode(ThemeMode newThemeMode) {
   if (newThemeMode != _themeMode) {
     _themeMode = newThemeMode;
     notifyListeners();
   }
 }
}


