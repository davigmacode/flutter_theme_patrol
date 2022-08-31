import 'package:flutter/material.dart';

/// The theme patrol data
///
/// Contains light and dark theme data, and the theme mode
class ThemePatrolData {
  /// Default constructor
  const ThemePatrolData({
    ThemeData? light,
    ThemeData? dark,
    this.mode = ThemeMode.system,
  }):
    this._light = light,
    this._dark = dark;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ThemePatrolData &&
    runtimeType == other.runtimeType &&
    _light == other._light &&
    _dark == other._dark &&
    mode == other.mode;

  @override
  int get hashCode => hashValues(_light, _dark, mode);

  /// The default light theme data
  final ThemeData? _light;

  /// The default dark theme data
  final ThemeData? _dark;

  /// The default theme mode
  ///
  /// Defaults to `ThemeMode.system`
  final ThemeMode mode;

  /// The light theme data
  ThemeData get light => _light ?? ThemeData.light();

  /// The dark theme data
  ThemeData get dark => _dark ?? ThemeData.dark();

  /// Whether the theme mode is [ThemeMode.light] or not
  bool get isLightMode => mode == ThemeMode.light;

  /// Whether the theme mode is [ThemeMode.dark] or not
  bool get isDarkMode => mode == ThemeMode.dark;

  /// Whether the theme mode is [ThemeMode.dark] or not
  bool get isSystemMode => mode == ThemeMode.dark;

  /// Creates a copy of this [ThemePatrolData] but with
  /// the given fields replaced with the new values.
  ThemePatrolData copyWith({
    ThemeData? light,
    ThemeData? dark,
    ThemeMode? mode,
  }) {
    return ThemePatrolData(
      light: this.light.copyWith(
        brightness: Brightness.light,
        colorScheme: light?.colorScheme,
        // cardTheme: light?.cardTheme,
        // buttonTheme: light?.buttonTheme,
        // buttonBarTheme: light?.buttonBarTheme,
        // dialogTheme: light?.dialogTheme,
        // iconTheme: light?.iconTheme,
        // appBarTheme: light?.appBarTheme,
        // chipTheme: light?.chipTheme,
        // sliderTheme: light?.sliderTheme,
        // textTheme: light?.textTheme
      ),
      dark: this.dark.copyWith(
        brightness: Brightness.dark,
        colorScheme: dark?.colorScheme,
        // cardTheme: dark?.cardTheme,
        // buttonTheme: dark?.buttonTheme,
        // buttonBarTheme: dark?.buttonBarTheme,
        // dialogTheme: dark?.dialogTheme,
        // iconTheme: dark?.iconTheme,
        // appBarTheme: dark?.appBarTheme,
        // chipTheme: dark?.chipTheme,
        // sliderTheme: dark?.sliderTheme,
        // textTheme: dark?.textTheme
      ),
      // light: light ?? this.light,
      // dark: dark ?? this.dark,
      mode: mode ?? this.mode,
    );
  }

  /// Returns a new [ThemePatrolData] that is
  /// a combination of this object and the given [other] style.
  ThemePatrolData merge(ThemePatrolData? other) {
    // if null return current object
    if (other == null) return this;

    return ThemePatrolData(
      light: other.light,
      dark: other.dark,
      mode: other.mode,
    );
  }

  /// Creates a copy of this [ThemePatrolData]
  /// but with the new color scheme value.
  ThemePatrolData toColor(Color seed) {
    return copyWith(
      light: ThemeData(brightness: Brightness.light, colorSchemeSeed: seed),
      dark: ThemeData(brightness: Brightness.dark, colorSchemeSeed: seed),
    );
  }

  /// Creates a copy of this [ThemePatrolData]
  /// but with the new mode value.
  ThemePatrolData toMode(ThemeMode mode) {
    return copyWith(mode: mode);
  }

  /// Creates a copy of this [ThemePatrolData]
  /// but set theme mode to [ThemeMode.light]
  ThemePatrolData toLightMode() {
    return toMode(ThemeMode.light);
  }

  /// Creates a copy of this [ThemePatrolData]
  /// but set theme mode to [ThemeMode.dark]
  ThemePatrolData toDarkMode() {
    return toMode(ThemeMode.dark);
  }

  /// Creates a copy of this [ThemePatrolData]
  /// but set theme mode to [ThemeMode.system]
  ThemePatrolData toSystemMode() {
    return toMode(ThemeMode.system);
  }
}

/// The widget builder to
typedef ThemePatrolBuilder = Widget Function(
    BuildContext context, ThemePatrolData theme);

/// A Widget that help you to keep an eyes on your app theme changes
class ThemePatrol extends StatefulWidget {
  /// Internal constructor
  ThemePatrol._({
    Key? key,
    required this.builder,
    required this.theme,
  }) : super(key: key);

  /// Default constructor
  factory ThemePatrol({
    Key? key,
    required ThemePatrolBuilder builder,
    ThemePatrolData? theme,
    ThemeData? light,
    ThemeData? dark,
    ThemeMode? mode,
  }) {
    return ThemePatrol._(
        key: key,
        builder: builder,
        theme: ThemePatrolData().merge(theme).copyWith(
              light: light,
              dark: dark,
              mode: mode,
            ));
  }

  /// Builder that gets called when the brightness or theme changes
  final ThemePatrolBuilder builder;

  /// Theme data
  final ThemePatrolData theme;

  @override
  ThemePatrolState createState() => ThemePatrolState();

  static ThemePatrolState of(BuildContext context) {
    final _InheritedState? result =
        context.dependOnInheritedWidgetOfExactType<_InheritedState>();
    assert(result != null, 'No ThemePatrolState found in context');
    return result!.data;
  }
}

class ThemePatrolState extends State<ThemePatrol> {
  /// The current theme data
  ThemePatrolData theme = ThemePatrolData();

  /// The current light theme data, shortcut to [theme.light]
  ThemeData get light => theme.light;

  /// The current dark theme data, shortcut to [theme.dark]
  ThemeData get dark => theme.dark;

  /// The current theme mode, shortcut to [theme.mode]
  ThemeMode get mode => theme.mode;

  /// Whether the current theme mode is [ThemeMode.light] or not
  bool get isLightMode => theme.isLightMode;

  /// Whether the current theme mode is [ThemeMode.dark] or not
  bool get isDarkMode => theme.isDarkMode;

  /// Whether the current theme mode is [ThemeMode.dark] or not
  bool get isSystemMode => theme.isSystemMode;

  /// Set the current theme
  void setTheme({
    ThemePatrolData? data,
    ThemeData? light,
    ThemeData? dark,
    ThemeMode? mode,
  }) {
    setState(() {
      theme = ThemePatrolData().merge(data).copyWith(
            light: light,
            dark: dark,
            mode: mode,
          );
    });
  }

  /// Set the color theme
  void setColor(Color color) {
    setTheme(
      data: theme,
      light: ThemeData(colorScheme: ColorScheme.fromSeed(brightness: Brightness.light, seedColor: color)),
      dark: ThemeData(colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: color, secondary: color)),
    );
  }

  /// Set the theme mode
  void setMode(ThemeMode mode) {
    setTheme(data: theme, mode: mode);
  }

  /// Set theme mode to [ThemeMode.light]
  void lightMode() {
    setMode(ThemeMode.light);
  }

  /// Set theme mode to [ThemeMode.dark]
  void darkMode() {
    setMode(ThemeMode.dark);
  }

  /// Set theme mode to [ThemeMode.system]
  void systemMode() {
    setMode(ThemeMode.system);
  }

  @override
  void initState() {
    super.initState();
    setTheme(data: widget.theme);
  }

  @override
  void didUpdateWidget(ThemePatrol oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.theme != widget.theme) {
      setTheme(data: widget.theme);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setTheme(data: widget.theme);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedState(
      data: this,
      child: widget.builder(context, theme)
    );
  }
}

class _InheritedState extends InheritedWidget {
   // Data is your entire state. In our case just 'User'
  final ThemePatrolState data;

  // You must pass through a child and your state.
  _InheritedState({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedState old) => true;
}