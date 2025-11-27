// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'app/theme/app_theme.dart';
import 'app/data/auth/auth_repository.dart';
import 'app/data/auth/auth_controller.dart';
import 'app/router/app_router.dart';
import 'features/gestion_pedidos/providers/order_provider.dart';
import 'features/dashboard_ingeniero/controllers/engineer_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AgroCoreApp());
}

class AgroCoreApp extends StatefulWidget {
  const AgroCoreApp({super.key});
  @override
  State<AgroCoreApp> createState() => _AgroCoreAppState();
}

class _AgroCoreAppState extends State<AgroCoreApp> {
  final _navKey = GlobalKey<NavigatorState>();

  late final AuthRepository _repo;
  late final AuthController _auth;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _repo = AuthRepository(baseUrl: 'https://real.blocsa.com');
    _auth = AuthController(_repo);

    _router = createRouter(_navKey, _auth);

    _auth.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: _repo),
        ChangeNotifierProvider<AuthController>.value(value: _auth),
        ChangeNotifierProvider<EngineerState>(
          create: (_) {
            final s = EngineerState();
            s.bootstrap();
            return s;
          },
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: industrialDarkTheme,
      ),
    );
  }
}
