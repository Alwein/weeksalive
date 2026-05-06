import 'package:flutter/material.dart';

class SetThemeModeAction {
  final ThemeMode themeMode;
  const SetThemeModeAction(this.themeMode);
}

class ThemeModeLoadedAction {
  final ThemeMode themeMode;
  const ThemeModeLoadedAction(this.themeMode);
}
