import 'package:flutter/widgets.dart';
import 'controller.dart';

typedef ThemeBuilder = Widget Function(
  BuildContext context,
  ThemeController theme,
);

typedef ThemeChanged = void Function(ThemeController theme);
