import 'dart:math';
import 'package:flutter/material.dart';
import 'types.dart';
import 'model.dart';

class ThemeController extends ChangeNotifier {
  /// Internal Constructor
  ThemeController._({
    required this.available,
    required this.modeIcons,
    this.initialMode = ThemeMode.system,
    this.initialTheme = 'default',
    ThemeChanged? onAvailableChanged,
    ThemeChanged? onThemeChanged,
    ThemeChanged? onModeChanged,
    ThemeChanged? onColorChanged,
    ThemeChanged? onChanged,
  })  : mode = initialMode,
        selected = initialTheme,
        _onAvailableChanged = onAvailableChanged,
        _onThemeChanged = onThemeChanged,
        _onModeChanged = onModeChanged,
        _onColorChanged = onColorChanged,
        _onChanged = onChanged;

  /// Controller which handles updating and controlling current theme.
  ///
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
  factory ThemeController({
    ThemeData? light,
    ThemeData? dark,
    ThemeExtensionIterable? extensions,
    ThemeExtensionBuilderIterable? extensionsBuilder,
    ThemeMap themes = const {},
    ThemeMode initialMode = ThemeMode.system,
    String? initialTheme,
    ThemeModeIcons? modeIcons,
    ThemeChanged? onAvailableChanged,
    ThemeChanged? onThemeChanged,
    ThemeChanged? onModeChanged,
    ThemeChanged? onColorChanged,
    ThemeChanged? onChanged,
  }) {
    final bool hasDefaultTheme = light != null || dark != null;
    final ThemeMap defaultTheme = hasDefaultTheme
        ? {
            'default': ThemeConfig.withMode(
              description: 'Default Theme',
              light: light,
              dark: dark,
              extensions: extensions,
              extensionsBuilder: extensionsBuilder,
            )
          }
        : {};
    final ThemeMap available = {...defaultTheme, ...themes};
    assert(
      available.isNotEmpty,
      'The available themes should not empty, provide [themes] or [light] or [dark]',
    );
    initialTheme =
        initialTheme == null ? available.entries.first.key : initialTheme;
    assert(
      available[initialTheme] != null,
      'The [initialTheme] should include in provided [themes]',
    );
    return ThemeController._(
      initialTheme: initialTheme,
      initialMode: initialMode,
      modeIcons: modeIcons ?? defaultModeIcons,
      available: available,
      onAvailableChanged: onAvailableChanged,
      onThemeChanged: onThemeChanged,
      onModeChanged: onModeChanged,
      onColorChanged: onColorChanged,
      onChanged: onChanged,
    );
  }

  /// Called when available themes changed
  ThemeChanged? _onAvailableChanged;

  /// Called when selected theme changed
  ThemeChanged? _onThemeChanged;

  /// Called when theme mode changed
  ThemeChanged? _onModeChanged;

  /// Called when theme color changed
  ThemeChanged? _onColorChanged;

  /// Called when selected theme or theme mode or theme color changed
  ThemeChanged? _onChanged;

  /// Initial provided theme name/key
  String initialTheme;

  /// Initial provided theme mode
  ThemeMode initialMode;

  /// Current selected theme name/key
  String selected;

  /// Return the current selected index
  int get selectedIndex =>
      availableEntries.indexWhere((e) => e.key == selected);

  /// Available themes to select
  ThemeMap available;

  /// Return the list of available themes
  ThemeList get availableEntries => available.entries.toList();

  /// Current selected theme mode
  ThemeMode mode;

  /// Map of the icons represent to the theme mode
  final ThemeModeIcons modeIcons;

  /// Default map of the icons represent to the theme mode
  static ThemeModeIcons defaultModeIcons = {
    ThemeMode.system: Icons.brightness_auto_rounded,
    ThemeMode.light: Icons.brightness_low_rounded,
    ThemeMode.dark: Icons.brightness_2_rounded
  };

  /// Return the icon represent to the current theme mode
  IconData get modeIcon {
    return modeIcons[mode]!;
  }

  /// This value will override the current theme color
  Color? color;

  /// The current theme config
  ThemeConfig get config => available[selected]!.toColor(color);

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

  /// Builder that returns iterable of [ThemeExtension]
  ThemeExtensionBuilderIterable? get extensionsBuilder =>
      config.extensionsBuilder;

  /// Builds a widget tree by applying a series of [ThemeExtension] builders to the given [child] widget.
  ///
  /// The [context] parameter is used to access the current build context.
  /// The [child] parameter is the widget to wrap with the theme extension builders.
  ///
  /// Returns the resulting widget tree.
  ///
  /// If [child] is `null`, a [SizedBox.shrink] widget is used as the default child.
  /// If [extensionsBuilder] is `null` or empty, the [child] is returned as is.
  /// Otherwise, the [child] is wrapped with a [Theme] widget for each [ThemeExtension] returned by [extensionsBuilder].
  /// The [Theme] widget applies the [ThemeExtension] to the current theme data using [Theme.of].
  /// The resulting widget tree is constructed by recursively calling [builders.fold] on the [child] and each [ThemeExtension] builder.
  TransitionBuilder bootstrap({bool sequentially = false}) {
    return (BuildContext _, Widget? child) {
      child ??= const SizedBox.shrink();

      final builders = extensionsBuilder;
      if (builders == null) return child;
      if (builders.isEmpty) return child;

      if (sequentially) {
        return builders.fold(
          child,
          (t, e) {
            return Builder(builder: (context) {
              final parent = Theme.of(context);
              return Theme(
                data: parent.copyWith(
                  extensions: [
                    ...parent.extensions.values,
                    e.call(context),
                  ],
                ),
                child: t,
              );
            });
          },
        );
      }

      return Theme(
        data: Theme.of(_).copyWith(
          extensions: extensionsBuilder?.map((e) => e(_)),
        ),
        child: child,
      );
    };
  }

  /// internal usage
  final _random = Random();

  /// Replace the available themes with new value
  void setThemes(ThemeMap themes) {
    this.available = themes;
    notifyListeners();
    this._onAvailableChanged?.call(this);
  }

  /// Update or insert one or multiple theme(s) to the available themes
  void mergeThemes(ThemeMap themes) {
    this.available.addAll(themes);
    notifyListeners();
    this._onAvailableChanged?.call(this);
  }

  /// Remove a theme by it's key from the available themes
  void removeTheme(String name) {
    this.available.remove(name);
    notifyListeners();
    this._onAvailableChanged?.call(this);
  }

  /// Set the current selected theme
  void select(String name) {
    assert(
      available[name] != null,
      'The [initialTheme] should include in provided [themes]',
    );
    this.selected = name;
    notifyListeners();
    this._onThemeChanged?.call(this);
    this._onChanged?.call(this);
  }

  void selectIndex(int index) {
    final theme = availableEntries[index];
    select(theme.key);
  }

  /// Cycle to next theme in the theme list.
  void selectNext() {
    final nextIndex = (selectedIndex + 1) % availableEntries.length;
    selectIndex(nextIndex);
  }

  /// Cycle to prev theme in the theme list.
  void selectPrev() {
    final prevIndex = (selectedIndex - 1) % availableEntries.length;
    selectIndex(prevIndex);
  }

  /// Select a random theme
  void selectRandom() {
    final maxIndex = availableEntries.length;
    int randomIndex;
    do {
      randomIndex = 0 + _random.nextInt(maxIndex - 0);
    } while (selectedIndex == randomIndex);
    selectIndex(randomIndex);
  }

  /// Override the theme color
  void toColor(Color? color) {
    this.color = color;
    notifyListeners();
    this._onColorChanged?.call(this);
    this._onChanged?.call(this);
  }

  /// Set the theme mode
  void toMode(ThemeMode mode) {
    this.mode = mode;
    notifyListeners();
    this._onModeChanged?.call(this);
    this._onChanged?.call(this);
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

  /// Toggle theme mode between [ThemeMode.light] and [ThemeMode.dark]
  void toggleMode() {
    final nextIndex = (mode.index + 1) % ThemeMode.values.length;
    final nextMode = ThemeMode.values[nextIndex];
    toMode(nextMode);
  }

  /// Reset all values to the initial provided value
  void reset() {
    this.selected = initialTheme;
    this.mode = initialMode;
    this.color = null;
    notifyListeners();
    this._onThemeChanged?.call(this);
    this._onModeChanged?.call(this);
    this._onColorChanged?.call(this);
    this._onChanged?.call(this);
  }

  /// Reset the selected theme to the initial provided value
  void resetTheme() {
    select(initialTheme);
  }

  /// Reset the theme mode to initial provided value
  void resetMode() {
    toMode(initialMode);
  }

  /// Reset the color scheme to the theme color
  void resetColor() {
    toColor(null);
  }
}
