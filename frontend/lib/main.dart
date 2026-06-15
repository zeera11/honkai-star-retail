import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PROVIDERS
import 'providers/cart_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';

// CORE
import 'core/app_theme.dart';

import 'data/datasources/local_inventory_datasource.dart';
import 'data/repositories/inventory_repository.dart';
import 'data/repositories/auth_repository.dart';

// SCREENS
import 'auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDataSource = LocalInventoryDataSource();

  final inventoryRepo = InventoryRepository(localDataSource);

  final authRepo = AuthRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => InventoryProvider(inventoryRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: const HSRApp(),
    ),
  );
}

class HSRApp extends StatelessWidget {
  const HSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final ThemeData lightTheme = AppTheme.generateTheme(
      isDark: false,
      fontPreset: settings.fontStyle,
      scale: settings.fontScale,
      highContrast: settings.highContrast,
    );

    final ThemeData darkTheme = AppTheme.generateTheme(
      isDark: true,
      fontPreset: settings.fontStyle,
      scale: settings.fontScale,
      highContrast: settings.highContrast,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Honkai Star Retail',

      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: lightTheme,

      darkTheme: darkTheme,

      // ─────────────────────────────────────
      // GLOBAL SETTINGS
      // ─────────────────────────────────────

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: settings.reduceMotion
            ? const ClampingScrollPhysics()
            : const BouncingScrollPhysics(),
      ),

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              settings.fontScale,
            ),
          ),
          child: child!,
        );
      },

      // ─────────────────────────────────────
      // GLOBAL PAGE TRANSITIONS
      // ─────────────────────────────────────

      themeAnimationCurve: Curves.easeOutCubic,

      themeAnimationDuration: const Duration(milliseconds: 450),

      // ─────────────────────────────────────
      // HOME
      // ─────────────────────────────────────

      home: const LoginPage(),
    );
  }
}
