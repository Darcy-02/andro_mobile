import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'ui/launch_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..loadPrefs(),
      child: const AndroApp(),
    ),
  );
}

class AndroApp extends StatelessWidget {
  const AndroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<AppState, ThemeMode>((s) => s.themeMode);
    return MaterialApp(
      title: 'ANDRO',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F0FA),
        fontFamily: 'SF Pro Display',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A7CF7),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0B0B1F),
        fontFamily: 'SF Pro Display',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A7CF7),
          brightness: Brightness.dark,
        ),
      ),
      home: const LaunchScreen(),
    );
  }
}
