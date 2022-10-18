import 'package:flutter/material.dart';

/// The theme config
///
/// Contains light and dark theme data, and the theme mode
class ThemeConfig {
  /// Default constructor
  const ThemeConfig._({
    required this.data,
    required this.darkData,
    this.description,
  });

  factory ThemeConfig({
    ThemeData? data,
    ThemeData? light,
    ThemeData? dark,
    String? description,
  }) =>
      ThemeConfig._(
        data: data ?? light ?? ThemeData.light(),
        darkData: dark ?? ThemeData.dark(),
        description: description,
      );

  factory ThemeConfig.fromColor(
    Color color, {
    String? description,
  }) =>
      ThemeConfig._(
        data: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: color,
        ),
        darkData: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: color,
          toggleableActiveColor: color,
        ),
        description: description,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfig &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          darkData == other.darkData &&
          description == other.description;

  @override
  int get hashCode => Object.hash(data, darkData, description);

  /// The main/light theme data
  final ThemeData data;

  /// The light theme data
  ThemeData get lightData => data;

  /// The dark theme data
  final ThemeData darkData;

  /// Short description which describes the theme
  final String? description;

  /// Creates a copy of this [ThemeConfig] but with
  /// the given fields replaced with the new values.
  ThemeConfig copyWith({
    ThemeData? data,
    ThemeData? light,
    ThemeData? dark,
    String? description,
  }) {
    return ThemeConfig(
      data: data ?? light ?? this.data,
      dark: dark ?? this.darkData,
      description: description ?? this.description,
    );
  }

  /// Returns a new [ThemeConfig] that is
  /// a combination of this object and the given [other] style.
  ThemeConfig merge(ThemeConfig? other) {
    // if null return current object
    if (other == null) return this;

    return ThemeConfig(
      data: other.data,
      dark: other.darkData,
      description: other.description,
    );
  }

  /// Creates a copy of this [ThemeConfig]
  /// but with the new color scheme value.
  ThemeConfig toColor(Color? color) {
    return copyWith(
      data: color != null
          ? this.data.copyWith(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: color,
                ),
              )
          : null,
      dark: color != null
          ? this.darkData.copyWith(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  brightness: Brightness.dark,
                  seedColor: color,
                ),
                toggleableActiveColor: color,
              )
          : null,
    );
  }

  /// Return [ColorScheme] based on the brightness from the given [BuildContext]
  ColorScheme colorSchemeOf(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? this.darkData.colorScheme
        : this.data.colorScheme;
  }
}

typedef ThemeMap = Map<String, ThemeConfig>;
typedef ThemeList = List<MapEntry<String, ThemeConfig>>;
typedef ThemeModeIcons = Map<ThemeMode, IconData>;
