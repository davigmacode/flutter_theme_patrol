import 'package:flutter/material.dart';
import 'package:theme_patrol/theme_patrol.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemePatrol(
      initialTheme: 'amber',
      initialMode: ThemeMode.system,
      themes: {
        'purple': ThemeConfig.fromColor(Colors.purple),
        'pink': ThemeConfig.fromColor(Colors.pink),
        'amber': ThemeConfig.fromColor(Colors.amber),
        'elegant': ThemeConfig(data: ThemeData()),
      },
      light: ThemeData(
        // becomes default light theme
        brightness: Brightness.light,
        colorSchemeSeed: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      dark: ThemeData(
        // becomes default dark theme
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.purple,
        toggleableActiveColor: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, theme) {
        return MaterialApp(
          title: 'ThemePatrol Example',
          theme: theme.data,
          darkTheme: theme.darkData,
          themeMode: theme.mode,
          home: const MyHomePage(title: 'ThemePatrol Example'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ThemePatrol.of(context).mode.toString()),
        actions: [
          ThemeConsumer(
            builder: (context, theme) {
              return Switch(
                value: theme.isDarkMode,
                onChanged: (selected) {
                  if (selected) {
                    theme.toDarkMode();
                  } else {
                    theme.toLightMode();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ThemeConsumer(
              builder: (context, theme) {
                return Wrap(
                  spacing: 5,
                  children: theme.available.entries
                      .map((e) => ActionChip(
                            label: Text(e.key),
                            onPressed: () => theme.select(e.key),
                            avatar: CircleAvatar(
                              backgroundColor:
                                  e.value.colorSchemeOf(context).primary,
                            ),
                          ))
                      .toList(),
                );
              },
            ),
            ColorPicker(
              pickerColor: Theme.of(context).colorScheme.primary,
              onColorChanged: (color) => ThemePatrol.of(context).toColor(color),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
