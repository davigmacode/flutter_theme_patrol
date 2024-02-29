import 'package:flutter/widgets.dart';
import 'controller.dart';

typedef ThemeBuilder = Widget Function(
  BuildContext context,
  ThemeController theme,
  Widget? child,
);

typedef ThemeChanged = void Function(ThemeController theme);
