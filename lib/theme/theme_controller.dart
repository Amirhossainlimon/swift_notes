import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<bool> isDark = ValueNotifier(false);

  static void toggleTheme() {
    isDark.value = !isDark.value;
  }
}
