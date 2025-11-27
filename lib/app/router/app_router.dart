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
import '../../features/gestion_siembra/pages/panel_siembra.dart';
import '../../features/gestion_pedidos/pages/orders_table_page.dart';

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
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/403', builder: (_, _) => const ForbiddenPage()),

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
      GoRoute(path: '/mapeo', builder: (_, _) => const PlantInventoryPage()),
      GoRoute(path: '/siembras', builder: (_, _) => const PanelSiembra()),
      GoRoute(path: '/pedidos', builder: (_, _) => const OrdersTablePage()),
      GoRoute(path: '/pos', builder: (_, _) => const _PosPage()),
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

        if (u.isAdmin) return null;

        if (u.isAgricultor) {
          if (loc.startsWith('/dashboard/agricultor')) return null;
          if (loc.startsWith('/mapeo')) return null;
          if (loc.startsWith('/pedidos')) return null;
          return '/403';
        }

        if (u.isIngeniero) {
          if (loc.startsWith('/dashboard/ingeniero')) return null;
          if (loc.startsWith('/mapeo')) return null;
          return '/403';
        }

        if (u.isPedidos) {
          if (loc.startsWith('/pedidos')) return null;
          return '/403';
        }

        return '/403';
      }

      return null;
    },
  );
}
