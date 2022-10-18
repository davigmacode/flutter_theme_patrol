import 'package:flutter/material.dart';
import 'controller.dart';
import 'provider.dart';
import 'consumer.dart';
import 'data.dart';
import 'model.dart';

class ThemePatrol extends StatelessWidget {
  const ThemePatrol._({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  /// [themes] is optional, it determine the map of [ThemeConfig] that will be available to select.
  /// if one of [light] and [dark] is provided,
  /// will create new theme called 'default' and merged to [themes].
  /// [AssertionError] will be thrown if the [themes] is empty.
  ///
  /// [initialTheme] is optional.
  /// If not provided, default theme will be the first provided theme.
  /// Otherwise the given theme will be set as the default theme.
  /// [AssertionError] will be thrown if there is no theme with [initialTheme].
  ///
  /// If the use case is only to switch between light/dark mode,
  /// simply provide [light], [dark], and [initialMode]
  ///
  /// If the use case is multiple theme without dark mode,
  /// simply provide [themes] and [initialTheme]
  ///
  /// If the use case is multiple theme with dark mode,
  /// provide [themes], [initialThemes], and [initialMode]
  factory ThemePatrol({
    ThemeData? light,
    ThemeData? dark,
    ThemeMap themes = const {},
    ThemeMode initialMode = ThemeMode.system,
    String? initialTheme,
    ThemeModeIcons? modeIcons,
    ThemeChanged? onAvailableChanged,
    ThemeChanged? onThemeChanged,
    ThemeChanged? onModeChanged,
    ThemeChanged? onColorChanged,
    ThemeChanged? onChanged,
    required ThemeBuilder builder,
  }) =>
      ThemePatrol._(
        controller: ThemeController(
          light: light,
          dark: dark,
          themes: themes,
          initialMode: initialMode,
          initialTheme: initialTheme,
          modeIcons: modeIcons,
          onAvailableChanged: onAvailableChanged,
          onThemeChanged: onThemeChanged,
          onModeChanged: onModeChanged,
          onColorChanged: onColorChanged,
          onChanged: onChanged,
        ),
        builder: builder,
      );

  /// Builder that gets called when the theme changes
  final ThemeBuilder builder;

  final ThemeController controller;

  static ThemeController of(BuildContext context) {
    return ThemeProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      controller: controller,
      child: ThemeConsumer(builder: builder),
    );
  }
}
