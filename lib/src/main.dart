import 'package:flutter/material.dart';
import 'controller.dart';
import 'provider.dart';

typedef ThemeBuilder = Widget Function(
  BuildContext context,
  ThemeController theme,
);

class ThemePatrol extends StatelessWidget {
  const ThemePatrol({
    Key? key,
    required this.light,
    required this.dark,
    this.mode = ThemeMode.system,
    required this.builder,
  }) : super(key: key);

  /// The light theme data
  final ThemeData light;

  /// The dark theme data
  final ThemeData dark;

  /// The theme mode
  ///
  /// Defaults to `ThemeMode.system`
  final ThemeMode mode;

  /// Builder that gets called when the brightness or theme changes
  final ThemeBuilder builder;

  static ThemeController of(BuildContext context) {
    return ThemeProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      notifier: ThemeController(
        light: light,
        dark: dark,
        mode: mode,
      ),
      child: Builder(builder: (context) {
        return builder(context, ThemeProvider.of(context));
      }),
    );
  }
}
