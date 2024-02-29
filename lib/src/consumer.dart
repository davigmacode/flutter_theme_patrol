import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'provider.dart';
import 'model.dart';

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
