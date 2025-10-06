import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../widgets/order_table_row.dart';
import 'create_order_page.dart';
import 'edit_order_page.dart';

class OrdersTablePage extends StatefulWidget {
  const OrdersTablePage({super.key});

  @override
  State<OrdersTablePage> createState() => _OrdersTablePageState();
}

class _OrdersTablePageState extends State<OrdersTablePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<OrderProvider>(context, listen: false);
      provider.loadOrders();
    });
  }

  void _showOrderDetails(OrderModel order) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        'Pedido #${order.id}',
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow('Cliente:', order.customer),
          _buildDetailRow('Cultivo:', order.crop),
          _buildDetailRow('Variedad:', order.variety),
          _buildDetailRow('Cantidad:', '${order.quantity} ${order.unit}'),
          _buildDetailRow('Fecha Entrega:', _formatDate(order.deliveryDate)),
          _buildDetailRow('Estado:', order.statusText),
          // Eliminados: precio unitario, total y dirección
          if (order.notes != null && order.notes!.isNotEmpty)
            _buildDetailRow('Notas:', order.notes!),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cerrar',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _navigateToEditOrder(order.id);
          },
          child: const Text(
            'Editar',
            style: TextStyle(color: Color(0xFF00CFC3)),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF00CFC3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _navigateToCreateOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateOrderPage(),
      ),
    );
  }

  void _navigateToEditOrder(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderPage(orderId: orderId),
      ),
    );
  }

  void _showShippingAlert(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Preparar Envío',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'El pedido #${order.id} ha sido marcado como "Enviado". '
          'Por favor, preparar los documentos de envío y coordinar '
          'con el transportista.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Color(0xFF00CFC3)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1C2E),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                child: const Text(
                  'Pedidos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Table Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: const Row(
                  children: [
                    _TableHeader(text: 'ID', flex: 1),
                    _TableHeader(text: 'Cliente', flex: 2),
                    _TableHeader(text: 'Cultivo', flex: 1),
                    _TableHeader(text: 'Variedad', flex: 1),
                    _TableHeader(text: 'Cantidad', flex: 1),
                    _TableHeader(text: 'Fecha Entrega', flex: 1), // NUEVA COLUMNA
                    _TableHeader(text: 'Estado', flex: 1),
                  ],
                ),
              ),

              // Table Body
              Expanded(
                child: provider.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00CFC3),
                        ),
                      )
                    : provider.orders.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay pedidos registrados',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.orders.length,
                            itemBuilder: (context, index) {
                              final order = provider.orders[index];
                              return OrderTableRow(
                                order: order,
                                onTap: () => _showOrderDetails(order),
                              );
                            },
                          ),
              ),

              // Add Button
              Container(
                margin: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: _navigateToCreateOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CFC3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Crear Pedido',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  final int flex;

  const _TableHeader({
    required this.text,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}