import 'package:flutter/material.dart';
import 'controller.dart';

typedef ThemeBuilder = Widget Function(
  BuildContext context,
  ThemeController theme,
  Widget? child,
);

typedef ThemeExtensionIterable = Iterable<ThemeExtension<dynamic>>;

typedef ThemeExtensionBuilder = ThemeExtensionIterable? Function(
  BuildContext context,
);

typedef ThemeChanged = void Function(ThemeController theme);
