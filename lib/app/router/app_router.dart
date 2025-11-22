// app/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../data/auth/auth_controller.dart';


import '../../features/dashboard_agricultor/pages/agricultor_home_page.dart';
import '../../features/dashboard_ingeniero/pages/ingeniero_home_page.dart';
import '../../features/panel/pages/panel_page.dart';
import '../../features/login/login.dart';
import '../../features/misc/pages/splash_page.dart';
import '../../features/misc/pages/forbidden_page.dart';


import '../../features/mapeo_plantulas/pages/plant_inventory_page.dart';


class _SiembrasPage extends StatelessWidget {
  const _SiembrasPage();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('Siembras (próximamente)')),
      );
}

class _PosPage extends StatelessWidget {
  const _PosPage();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('POS (próximamente)')),
      );
}


GoRouter createRouter(
  GlobalKey<NavigatorState> key,
  AuthController auth,
) {
  return GoRouter(
    navigatorKey: key,
    initialLocation: '/splash',
    refreshListenable: auth, 
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashPage()),
      GoRoute(path: '/login',  builder: (_, _) => const LoginPage()),
      GoRoute(path: '/403',    builder: (_, _) => const ForbiddenPage()),

      // Dashboards
      GoRoute(
        path: '/dashboard/agricultor',
        builder: (_, _) => const AgricultorHomePage(),
      ),
      GoRoute(
        path: '/dashboard/ingeniero',
        builder: (_, _) => const IngenieroHomePage(),
      ),

      GoRoute(path: '/panel', builder: (_, _) => const PanelPage()),

      GoRoute(
        path: '/mapeo',
        builder: (_, _) => const PlantInventoryPage(),
      ),
      GoRoute(
        path: '/siembras',
        builder: (_, _) => const _SiembrasPage(),
      ),
      GoRoute(
        path: '/pos',
        builder: (_, _) => const _PosPage(),
      ),
    ],
    redirect: (context, state) {
      final loc = state.matchedLocation;

      if (auth.status == AuthStatus.unknown || auth.status == AuthStatus.loading) {
        return (loc == '/splash') ? null : '/splash';
      }

      if (auth.status == AuthStatus.unauthenticated) {
        return (loc == '/login') ? null : '/login';
      }

      if (auth.status == AuthStatus.authenticated) {
        if (loc == '/splash' || loc == '/login' || loc == '/') {
          return auth.preferredHome();
        }
        final u = auth.currentUser!;
        if (loc.startsWith('/dashboard/ingeniero') && !u.isIngeniero && !u.isAdmin) {
          return '/403';
        }
        if (loc.startsWith('/dashboard/agricultor') && !u.isAgricultor && !u.isAdmin) {
          return '/403';
        }
        if (loc.startsWith('/mapeo') && !(u.isIngeniero || u.isAdmin)) {
          return '/403';
        }
        if (loc.startsWith('/siembras') && !(u.isAgricultor || u.isAdmin)) {
          return '/403';
        }
        if (loc.startsWith('/pos') && !u.isAdmin) {
          return '/403';
        }
        return null;
      }

      return null;
    },
  );
}
