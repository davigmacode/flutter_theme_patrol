import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'controller.dart';
import 'types.dart';
import 'data.dart';

class ThemeConsumer extends StatelessWidget {
  const ThemeConsumer({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// Builder that gets called when the theme changes
  final ThemeBuilder builder;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, ThemeProvider.of(context), child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ThemeBuilder>.has('builder', builder));
    properties.add(DiagnosticsProperty<Widget?>('child', child));
  }
}

class ThemeProvider extends InheritedNotifier<ThemeController>
    with Diagnosticable {
  const ThemeProvider({
    Key? key,
    required ThemeController controller,
    required Widget child,
  }) : super(key: key, notifier: controller, child: child);

  ThemeProvider.builder({
    Key? key,
    required ThemeController controller,
    required ThemeBuilder builder,
    Widget? child,
  }) : super(
          key: key,
          notifier: controller,
          child: ThemeConsumer(
            builder: builder,
            child: child,
          ),
        );

  static ThemeController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'No ThemeProvider or ThemePatrol found in context');
    return result!.notifier!;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ThemeController>('notifier', notifier));
  }
}

class ThemePatrol extends StatelessWidget with Diagnosticable {
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
  ThemePatrol({
    Key? key,
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
    required this.builder,
    this.child,
  })  : controller = ThemeController(
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
        super(key: key);

  /// Builder that gets called when the theme changes
  final ThemeBuilder builder;

  /// The widget below this widget in the tree
  final Widget? child;

  /// Manages available and selected theme, also notifies listeners of changes
  final ThemeController controller;

  /// The [ThemeController] from the closest instance of
  /// this class that encloses the given context.
  static ThemeController of(BuildContext context) {
    return ThemeProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider.builder(
      controller: controller,
      builder: builder,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ThemeBuilder>.has('builder', builder));
    properties.add(DiagnosticsProperty<Widget?>('child', child));
    properties
        .add(DiagnosticsProperty<ThemeController>('controller', controller));
  }
}
