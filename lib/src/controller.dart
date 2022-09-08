import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._({
    required this.name,
    required this.available,
    required this.mode,
  });

  factory ThemeController({
    ThemeData? data,
    ThemeData? light,
    ThemeData? dark,
    ThemeMap themes = const {},
    ThemeMode initialMode = ThemeMode.system,
    String initialTheme = 'default',
  }) {
    return ThemeController._(
      name: initialTheme,
      mode: initialMode,
      available: {
        'default': ThemeConfig(
          description: 'Default Theme',
          data: data,
          light: light,
          dark: dark,
        )
      }..addAll(themes),
    );
  }

  /// Current theme name
  String name;

  /// Available themes to select
  ThemeMap available;

  /// The theme mode
  ///
  /// Defaults to `ThemeMode.system`
  ThemeMode mode;

  /// This value will override the current theme color
  Color? color;

  /// The current theme config
  ThemeConfig get config => (available[name] ?? ThemeConfig()).toColor(color);

  /// The current theme description
  String? get description => config.description;

  /// The current main/light theme data
  ThemeData get data => config.data;

  /// The current light theme data
  ThemeData get lightData => config.lightData;

  /// The current dark theme data
  ThemeData get darkData => config.darkData;

  /// Whether the theme mode is [ThemeMode.light] or not
  bool get isLightMode => mode == ThemeMode.light;

  /// Whether the theme mode is [ThemeMode.dark] or not
  bool get isDarkMode => mode == ThemeMode.dark;

  /// Whether the theme mode is [ThemeMode.dark] or not
  bool get isSystemMode => mode == ThemeMode.system;

  /// Replace the available themes with new value
  void setAvailable(ThemeMap themes) {
    this.available = themes;
    notifyListeners();
  }

  /// Update or insert theme(s) to the available themes
  void mergeTheme(ThemeMap themes) {
    this.available.addAll(themes);
    notifyListeners();
  }

  /// Remove a theme by it's key from the available themes
  void removeTheme(String name) {
    this.available.remove(name);
    notifyListeners();
  }

  /// Set the current selected theme
  void select(String name) {
    this.name = name;
    notifyListeners();
  }

  /// Override the theme color
  void toColor(Color? color) {
    this.color = color;
    notifyListeners();
  }

  /// Reset the color scheme to the theme color
  void resetColor() {
    toColor(null);
  }

  /// Set the theme mode
  void toMode(ThemeMode mode) {
    this.mode = mode;
    notifyListeners();
  }

  /// Set theme mode to [ThemeMode.light]
  void toLightMode() {
    toMode(ThemeMode.light);
  }

  /// Set theme mode to [ThemeMode.dark]
  void toDarkMode() {
    toMode(ThemeMode.dark);
  }

  /// Set theme mode to [ThemeMode.system]
  void toSystemMode() {
    toMode(ThemeMode.system);
  }
}
