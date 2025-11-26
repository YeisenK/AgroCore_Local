import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../app/core/constants/routes.dart';
import '../notifiers/siembra_notifier.dart';
import '../repositories/mock_siembra_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_MX', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SiembraNotifier(MockSiembraRepository()),
      child: MaterialApp(
        title: 'Gestión de Vivero',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,

        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,

          scaffoldBackgroundColor: Colors.black,

          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.blue, 
          ),

          textTheme: const TextTheme(
            titleMedium: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(color: Colors.blue),
            bodySmall: TextStyle(color: Colors.blue),
          ),
        ),

        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: Routes.siembraList,
      ),
    );
  }
}
