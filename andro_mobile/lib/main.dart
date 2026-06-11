import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'ui/theme_colors.dart';
import 'dev_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FFI needed for sqflite on desktop
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const ProviderScope(child: AndroApp()));
}

class AndroApp extends StatefulWidget {
  const AndroApp({super.key});

  @override
  State<AndroApp> createState() => _AndroAppState();
}

class _AndroAppState extends State<AndroApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Andro',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AndroColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AndroColors.lightAccent,
          surface: AndroColors.lightSurface,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AndroColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AndroColors.darkAccent,
          surface: AndroColors.darkSurface,
        ),
      ),
      // TODO: swap DevMenu for LandingPage when Darcy's router is ready
      home: const DevMenu(),
    );
  }
}
