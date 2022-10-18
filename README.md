![Pub Version](https://img.shields.io/pub/v/theme_patrol) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_theme_patrol)

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="195" height="55"></a>

Keep an eyes on your app theme changes, comes with a powerful set of tools to manage multiple themes with or without theme mode.

[![Preview](https://github.com/davigmacode/flutter_theme_patrol/raw/master/media/preview.gif)](https://davigmacode.github.io/flutter_theme_patrol)

[Demo](https://davigmacode.github.io/flutter_theme_patrol)

## Features

* Switch between light/dark mode
* Switch between multiple themes
* Override current theme color

## Usage

To read more about classes and other references used by `theme_patrol`, see the [API Reference](https://pub.dev/documentation/theme_patrol/latest/).

### Basic usage
```dart
// configuring
ThemePatrol(
  initialMode: ThemeMode.system,
  light: ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.purple,
  ),
  dark: ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.purple,
    toggleableActiveColor: Colors.purple,
  ),
  builder: (context, theme) {
    return MaterialApp(
      title: 'ThemePatrol',
      theme: theme.data, // or theme.lightData
      darkTheme: theme.darkData,
      themeMode: theme.mode,
      home: HomePage(),
    );
  },
);

// consuming
ThemeController theme = ThemePatrol.of(context);
ThemeController theme = ThemeProvider.of(context);
ThemeConsumer(
  builder: (context, theme) {
    return Container();
  },
);
```

### Verbose usage
```dart
// configuring
ThemeProvider(
  controller: ThemeController(
    initialMode: ThemeMode.system,
    light: ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.purple,
    ),
    ...
  ),
  child: ThemeConsumer(
    builder: (context, theme) {
      return MaterialApp(
        title: 'ThemePatrol',
        theme: theme.data, // or theme.lightData
        darkTheme: theme.darkData,
        themeMode: theme.mode,
        home: HomePage(),
      );
    },
  ),
);

// consuming
ThemeController theme = ThemeProvider.of(context);
ThemeConsumer(
  builder: (context, theme) {
    return Container();
  },
);
```

### [Provider](https://pub.dev/packages/provider) usage
To read more about classes and other references used by `provider`, see their [API Reference](https://pub.dev/documentation/provider/latest/).
```dart
// configuring
ChangeNotifierProvider(
  create: (_) => ThemeController(
    initialMode: ThemeMode.system,
    ...
  ),
  child: ...
);

// consuming
ThemeController theme = Provider.of<ThemeController>(context, listen: true|false);
ThemeController theme = context.watch<ThemeController>();
ThemeController theme = context.read<ThemeController>();
ThemeMode mode = context.select((ThemeController theme) => theme.mode);
Consumer<ThemeController>(
  builder: (_, theme, child) {
    return Foo();
  },
  child: Baz(),
);
```

## Use Case

### Only switch between light/dark mode

```dart
ThemePatrol(
  initialMode: ThemeMode.system,
  light: ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.purple,
  ),
  dark: ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.purple,
    toggleableActiveColor: Colors.purple,
  ),
  builder: (context, theme) {
    return MaterialApp(
      title: 'ThemePatrol',
      theme: theme.data, // or theme.lightData
      darkTheme: theme.darkData,
      themeMode: theme.mode,
      home: Scaffold(
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
      ),
    );
  },
);
```

### Multiple theme without dark mode

```dart
ThemePatrol(
  initialTheme: 'amber',
  themes: {
    'purple': ThemeConfig.fromColor(Colors.purple),
    'pink': ThemeConfig.fromColor(Colors.pink),
    'amber': ThemeConfig.fromColor(Colors.amber),
    'elegant': ThemeConfig(data: ThemeData()),
  },
  builder: (context, theme) {
    return MaterialApp(
      title: 'ThemePatrol',
      theme: theme.data, // or theme.lightData
      home: Scaffold(
        appBar: AppBar(
          title: Text(ThemePatrol.of(context).selected),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ThemeConsumer(
                builder: (context, theme) {
                  return Wrap(
                    spacing: 5,
                    children: theme.availableEntries
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
            ],
          ),
        ),
      ),
    );
  },
);
```

### Multiple theme with dark mode

```dart
ThemePatrol(
  initialTheme: 'amber',
  initialMode: ThemeMode.system,
  themes: {
    'purple': ThemeConfig.fromColor(Colors.purple),
    'pink': ThemeConfig.fromColor(Colors.pink),
    'amber': ThemeConfig.fromColor(Colors.amber),
    'basic': ThemeConfig(data: ThemeData()),
    'pro': ThemeConfig(data: ThemeData(), dark: ThemeData()),
    'premium': ThemeConfig(light: ThemeData(), dark: ThemeData()),
  },
  builder: (context, theme) {
    return MaterialApp(
      title: 'ThemePatrol',
      theme: theme.data, // or theme.lightData
      darkTheme: theme.darkData,
      themeMode: theme.mode,
      home: Scaffold(
        appBar: AppBar(
          title: Text(ThemePatrol.of(context).selected),
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
            ],
          ),
        ),
      ),
    );
  },
);
```