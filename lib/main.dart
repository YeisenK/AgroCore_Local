// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// importa tu login
import 'pages/login.dart';
// importa tus dashboards
import 'dashboards/ingeniero_Dashboard.dart';

void main() => runApp(const AgroCoreApp());

class AgroCoreApp extends StatelessWidget {
  const AgroCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroCore',
      debugShowCheckedModeBanner: false,
      theme: _appTheme,
      initialRoute: Routes.login,
      routes: {
        // LOGIN
        Routes.login: (_) => const LoginPage(),

        // DASHBOARDS
        Routes.engineer: (_) => ChangeNotifierProvider(
              create: (_) => EngineerState()..bootstrap(),
              child: const EngineerDashboardPage(),
            ),
        // cuando tengas más dashboards, solo agregas:
        // Routes.admin: (_) => const AdminDashboardPage(),
        // Routes.farmer: (_) => const FarmerDashboardPage(),
      },
    );
  }
}

/* ===== RUTAS CENTRALIZADAS ===== */
abstract class Routes {
  static const String login = '/';
  static const String engineer = '/dashboards/engineer';
  // static const String admin = '/dashboards/admin';
  // static const String farmer = '/dashboards/farmer';
}

/* ===== THEME OSCURO ===== */
final ThemeData _appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1F2A30),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF2BB4AA),
    secondary: Color(0xFF4FB3C8),
    surface: Color(0xFF2A343B),
    background: Color(0xFF1F2A30),
    error: Color(0xFFD35B5B),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2A343B),
    foregroundColor: Color(0xFFD9E1E8),
  ),
);
