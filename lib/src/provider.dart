import 'package:flutter/widgets.dart';
import 'controller.dart';

class ThemeProvider extends InheritedNotifier<ThemeController> {
  const ThemeProvider({
    Key? key,
    required ThemeController notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ThemeController of(BuildContext context) {
    final ThemeProvider? result =
        context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'No ThemePatrol found in context');
    return result!.notifier!;
  }
}
