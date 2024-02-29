import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'controller.dart';
import 'consumer.dart';
import 'model.dart';

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
