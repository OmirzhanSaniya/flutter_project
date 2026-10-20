import 'package:flutter/material.dart';

import 'models/event.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'shell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// R11: theme mode lives above MaterialApp.
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  /// R22: both themes come from ColorScheme.fromSeed.
  ThemeData _theme(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          brightness: brightness,
        ),
      );

  /// R25: detail and form are built from typed arguments.
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    if (settings.name == Routes.detail && args is DetailArgs) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => DetailScreen(args: args),
      );
    }
    if (settings.name == Routes.form && args is FormArgs) {
      return MaterialPageRoute<Event>(
        settings: settings,
        builder: (_) => FormScreen(event: args.event),
      );
    }
    return null;
  }

  Route<dynamic> _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const Scaffold(body: Center(child: Text('Not found'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Events',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      routes: {
        Routes.shell: (_) =>
            Shell(themeMode: _themeMode, onThemeMode: _setThemeMode),
      },
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
    );
  }
}
