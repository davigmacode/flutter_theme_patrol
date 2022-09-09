import 'package:flutter/widgets.dart';
import 'provider.dart';
import 'model.dart';

class ThemeConsumer extends StatelessWidget {
  const ThemeConsumer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// Builder that gets called when the theme changes
  final ThemeBuilder builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, ThemeProvider.of(context));
  }
}
