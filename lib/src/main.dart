import 'package:flutter/material.dart';
import 'controller.dart';
import 'provider.dart';
import 'consumer.dart';
import 'theme.dart';
import 'builder.dart';

class ThemePatrol extends StatelessWidget {
  const ThemePatrol._({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  factory ThemePatrol({
    ThemeData? light,
    ThemeData? dark,
    ThemeMap themes = const {},
    ThemeMode initialMode = ThemeMode.system,
    String initialTheme = 'default',
    required ThemeBuilder builder,
  }) =>
      ThemePatrol._(
        controller: ThemeController(
          initialMode: initialMode,
          initialTheme: initialTheme,
          themes: themes,
          light: light,
          dark: dark,
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
