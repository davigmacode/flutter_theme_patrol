import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({
    ThemeData? light,
    ThemeData? dark,
    ThemeMode? mode,
  })  : _light = light,
        _dark = dark,
        _mode = mode;

  /// The light theme data
  ThemeData? _light;

  /// The dark theme data
  ThemeData? _dark;

  /// The theme mode
  ///
  /// Defaults to `ThemeMode.system`
  ThemeMode? _mode;

  /// The light theme data
  ThemeData get light => _light ?? ThemeData.light();

  /// The dark theme data
  ThemeData get dark => _dark ?? ThemeData.dark();

  /// The theme mode
  ThemeMode get mode => _mode ?? ThemeMode.system;

  /// Whether the theme mode is [ThemeMode.light] or not
  bool get isLightMode => mode == ThemeMode.light;

  /// Whether the theme mode is [ThemeMode.dark] or not
  bool get isDarkMode => mode == ThemeMode.dark;

  /// Whether the theme mode is [ThemeMode.dark] or not
  bool get isSystemMode => mode == ThemeMode.system;

  /// Set the theme
  void setTheme({
    ThemeData? light,
    ThemeData? dark,
    ThemeMode? mode,
  }) {
    _light = light;
    _dark = dark;
    _mode = mode;
  }

  /// Set the color theme
  void setColor(Color color) {
    _light = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: color,
      ),
    );
    _dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: color,
      ),
    );
    notifyListeners();
  }

  /// Set the theme mode
  void setMode(ThemeMode value) {
    _mode = value;
    notifyListeners();
  }

  /// Set theme mode to [ThemeMode.light]
  void setLightMode() {
    setMode(ThemeMode.light);
  }

  /// Set theme mode to [ThemeMode.dark]
  void setDarkMode() {
    setMode(ThemeMode.dark);
  }

  /// Set theme mode to [ThemeMode.system]
  void setSystemMode() {
    setMode(ThemeMode.system);
  }
}
