import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'features/orders/pages/orders_table_page.dart';
import 'features/orders/providers/order_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Gestión de Pedidos',
        theme: AppTheme.darkTheme,
        home: const OrdersTablePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}