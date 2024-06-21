import 'package:flutter/material.dart';
import 'controller.dart';

typedef ThemeBuilder = Widget Function(
  BuildContext context,
  ThemeController theme,
  Widget? child,
);

typedef ThemeExtensionIterable = List<ThemeExtension<dynamic>>;

typedef ThemeExtensionBuilder = ThemeExtension<dynamic> Function(
  BuildContext context,
);

typedef ThemeExtensionBuilderIterable = List<ThemeExtensionBuilder>;

typedef ThemeChanged = void Function(ThemeController theme);
