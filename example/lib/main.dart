import 'package:flutter/material.dart';
import 'package:theme_patrol/theme_patrol.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemePatrol(
      light: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      mode: ThemeMode.system,
      builder: (context, theme) {
        return MaterialApp(
          title: 'ThemePatrol Example',
          theme: theme.light,
          darkTheme: theme.dark,
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
          Switch(
            value: ThemePatrol.of(context).isDarkMode,
            onChanged: (selected) {
              if (selected) {
                ThemePatrol.of(context).setDarkMode();
              } else {
                ThemePatrol.of(context).setLightMode();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleColorPicker(
              // initialColor: Theme.of(context).primaryColor,

              onChanged: (color) => ThemePatrol.of(context).setColor(color),
              size: const Size(240, 240),
              strokeWidth: 4,
              thumbSize: 36,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
