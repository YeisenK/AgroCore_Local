import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/core/widgets/app_shell.dart';
import '../../../app/data/auth/auth_controller.dart';

class _RoleSwitcherAction extends StatelessWidget {
  const _RoleSwitcherAction();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final roles = auth.currentUser?.roles ?? const <String>[];

    if (roles.isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      tooltip: 'Volver a selección de usuario',
      icon: const Icon(Icons.switch_account),
      onPressed: () => context.go(auth.preferredHome()),
    );
  }
}

class AgricultorHomePage extends StatefulWidget {
  const AgricultorHomePage({super.key});

  @override
  State<AgricultorHomePage> createState() => _AgricultorHomePageState();
}

class _AgricultorHomePageState extends State<AgricultorHomePage> {
  // Controladores
  Timer? _refreshTimer;
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  // Estado
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedIndex = 0;
  String _selectedOrderFilter = 'Todos';
  double _chartInterval = 4.0;

  // Datos (inicialmente vacíos - se llenarán desde APIs)
  int _activeOrders = 0;
  int _upcomingDeliveries = 0;
  double _avgHumidity = 0.0;
  double _currentTemperature = 0.0;
  
  final List<FlSpot> _humidityData = [];
  final List<FlSpot> _temperatureData = [];
  final List<Map<String, dynamic>> _recentOrders = [];
  final List<Map<String, dynamic>> _alerts = [];

  // Getter para pedidos filtrados y buscados
  List<Map<String, dynamic>> get _searchedOrders {
    var filtered = _recentOrders;
    
    // Aplicar filtro de estado
    if (_selectedOrderFilter != 'Todos') {
      filtered = filtered.where((order) => 
        order['estado'] == _selectedOrderFilter
      ).toList();
    }
    
    // Aplicar búsqueda
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((order) =>
        order['cliente'].toString().toLowerCase().contains(query) ||
        order['productos'].toString().toLowerCase().contains(query) ||
        order['estado'].toString().toLowerCase().contains(query)
      ).toList();
    }
    
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    
    // Configurar actualización automática cada 30 segundos
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _refreshData();
    });
  }

  // Cargar datos iniciales
  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Reemplazar con llamadas reales a tus APIs
      await Future.wait([
        _loadKPIData(),
        _loadChartData(),
        _loadOrdersData(),
        _loadAlertsData(),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error cargando datos: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Actualizar datos
  Future<void> _refreshData() async {
    if (_isLoading) return;

    try {
      // TODO: Reemplazar con llamadas reales a tus APIs
      await Future.wait([
        _loadKPIData(),
        _loadChartData(),
        _loadOrdersData(),
        _loadAlertsData(),
      ]);
    } catch (e) {
      // No mostramos error en refresh automático para no molestar al usuario
      print('Error en refresh automático: $e');
    }
  }

  // TODO: Implementar estas funciones con tus servicios reales
  Future<void> _loadKPIData() async {
    // Ejemplo de estructura JSON esperada:
    /*
    {
      "active_orders": 12,
      "upcoming_deliveries": 5,
      "avg_humidity": 68.5,
      "current_temperature": 24.3
    }
    */
    
    // Simulación - reemplazar con:
    // final response = await http.get(Uri.parse('https://tu-api.com/agricultor/kpi'));
    // final data = json.decode(response.body);
    
    await Future.delayed(const Duration(milliseconds: 500)); // Remover esta línea
    
    setState(() {
      _activeOrders = 0; // data['active_orders']
      _upcomingDeliveries = 0; // data['upcoming_deliveries']
      _avgHumidity = 0.0; // data['avg_humidity']
      _currentTemperature = 0.0; // data['current_temperature']
    });
  }

  Future<void> _loadChartData() async {
    // Ejemplo de estructura JSON esperada:
    /*
    {
      "humidity_data": [
        {"x": 0, "y": 65.2},
        {"x": 1, "y": 66.8},
        ...
      ],
      "temperature_data": [
        {"x": 0, "y": 23.1},
        {"x": 1, "y": 23.8},
        ...
      ]
    }
    */
    
    // Simulación - reemplazar con:
    // final response = await http.get(Uri.parse('https://tu-api.com/agricultor/chart-data'));
    // final data = json.decode(response.body);
    
    await Future.delayed(const Duration(milliseconds: 300)); // Remover esta línea
    
    setState(() {
      _humidityData.clear();
      _temperatureData.clear();
      
      // data['humidity_data'].forEach((point) {
      //   _humidityData.add(FlSpot(point['x'], point['y']));
      // });
      // data['temperature_data'].forEach((point) {
      //   _temperatureData.add(FlSpot(point['x'], point['y']));
      // });
    });
  }

  Future<void> _loadOrdersData() async {
    // Ejemplo de estructura JSON esperada:
    /*
    [
      {
        "id": 1,
        "cliente": "Supermercado Oaxaca",
        "fecha": "2024-01-15T10:00:00Z",
        "estado": "en_camino",
        "productos": "Tomates (50kg), Lechugas (30kg)",
        "direccion": "Av. Principal 123, Oaxaca",
        "total": 1250.00,
        "telefono": "+1234567890",
        "notas": "Entregar en recepción"
      },
      ...
    ]
    */
    
    // Simulación - reemplazar con:
    // final response = await http.get(Uri.parse('https://tu-api.com/agricultor/orders'));
    // final data = json.decode(response.body);
    
    await Future.delayed(const Duration(milliseconds: 400)); // Remover esta línea
    
    setState(() {
      _recentOrders.clear();
      // _recentOrders.addAll(data.map((order) => _parseOrder(order)).toList());
    });
  }

  Future<void> _loadAlertsData() async {
    // Ejemplo de estructura JSON esperada:
    /*
    [
      {
        "id": 1,
        "tipo": "humedad_baja",
        "mensaje": "Humedad crítica en Invernadero 2",
        "nivel": "alto",
        "fecha": "2024-01-15T08:30:00Z",
        "detalles": "La humedad ha bajado al 45%. Se recomienda activar el sistema de riego.",
        "resuelta": false,
        "invernadero_id": 2,
        "sensor_id": "S012"
      },
      ...
    ]
    */
    
    // Simulación - reemplazar con:
    // final response = await http.get(Uri.parse('https://tu-api.com/agricultor/alerts'));
    // final data = json.decode(response.body);
    
    await Future.delayed(const Duration(milliseconds: 350)); // Remover esta línea
    
    setState(() {
      _alerts.clear();
      // _alerts.addAll(data.map((alert) => _parseAlert(alert)).toList());
    });
  }

  // TODO: Implementar función para parsear alertas
  Map<String, dynamic> _parseAlert(Map<String, dynamic> alertData) {
    return {
      'id': alertData['id'],
      'mensaje': alertData['mensaje'],
      'nivel': _translateAlertLevel(alertData['nivel']),
      'fecha': _formatDate(alertData['fecha']),
      'detalles': alertData['detalles'],
      'resuelta': alertData['resuelta'],
      'rawData': alertData, // Mantener datos originales
    };
  }

  // Utilidades para formateo
  String _formatDate(String isoDate) {
    // TODO: Implementar formateo de fecha según tu zona horaria
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _translateStatus(String status) {
    // TODO: Mapear estados del backend a textos legibles
    const statusMap = {
      'programado': 'Programado',
      'preparando': 'Preparando',
      'en_camino': 'En camino',
      'entregado': 'Entregado',
      'cancelado': 'Cancelado',
    };
    return statusMap[status] ?? status;
  }

  String _translateAlertLevel(String level) {
    // TODO: Mapear niveles del backend a textos legibles
    const levelMap = {
      'bajo': 'Bajo',
      'medio': 'Medio',
      'alto': 'Alto',
      'critico': 'Crítico',
    };
    return levelMap[level] ?? level;
  }

  // Acciones
  Future<void> _addNewOrder() async {
    // TODO: Implementar creación de nuevo pedido
    // Navigator.push(context, MaterialPageRoute(builder: (_) => CreateOrderPage()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Funcionalidad de crear pedido - Por implementar'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _resolveAlert(int alertId) async {
    // TODO: Implementar resolución de alerta
    // await http.put(Uri.parse('https://tu-api.com/alerts/$alertId/resolve'));
    
    setState(() {
      final alertIndex = _alerts.indexWhere((alert) => alert['id'] == alertId);
      if (alertIndex != -1) {
        _alerts[alertIndex]['resuelta'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Alerta marcada como resuelta'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  Future<void> _deleteAlert(int alertId) async {
    // TODO: Implementar eliminación de alerta
    // await http.delete(Uri.parse('https://tu-api.com/alerts/$alertId'));
    
    setState(() {
      _alerts.removeWhere((alert) => alert['id'] == alertId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Alerta eliminada'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

@override
void dispose() {
  _refreshTimer?.cancel();
  _pageController.dispose();
  _searchController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return AppShell(
    title: 'Dashboard Agricultor',
    actions: [
      const _RoleSwitcherAction(), // Cambiado aquí
      if (_isLoading)
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _refreshData,
        tooltip: 'Actualizar datos',
      ),
    ],
    body: _isLoading && _recentOrders.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadInitialData,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Bottom Navigation Bar personalizado
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildNavItem(0, Icons.dashboard, 'Dashboard'),
                        _buildNavItem(1, Icons.shopping_cart, 'Pedidos'),
                        _buildNavItem(2, Icons.warning, 'Alertas'),
                        _buildNavItem(3, Icons.settings, 'Configuración'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      children: [
                        _buildDashboardPage(),
                        _buildOrdersPage(),
                        _buildAlertsPage(),
                        _buildSettingsPage(),
                      ],
                    ),
                  ),
                ],
              ),
  );
}

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Expanded(
      child: Material(
        color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardPage() {
    final unresolvedAlerts = _alerts.where((alert) => !alert['resuelta']).toList();
    final recentOrders = _recentOrders.take(3).toList();

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPIs
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        KpiCard(
                          title: 'Pedidos activos', 
                          value: _activeOrders.toString(),
                          icon: Icons.shopping_cart,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 10),
                        KpiCard(
                          title: 'Próximas entregas', 
                          value: _upcomingDeliveries.toString(),
                          icon: Icons.local_shipping,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 10),
                        KpiCard(
                          title: 'Humedad Prom.', 
                          value: '${_avgHumidity.toStringAsFixed(1)}%',
                          icon: Icons.water_drop,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KpiCard(
                          title: 'Pedidos activos', 
                          value: _activeOrders.toString(),
                          icon: Icons.shopping_cart,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        KpiCard(
                          title: 'Próximas entregas', 
                          value: _upcomingDeliveries.toString(),
                          icon: Icons.local_shipping,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        KpiCard(
                          title: 'Humedad Prom.', 
                          value: '${_avgHumidity.toStringAsFixed(1)}%',
                          icon: Icons.water_drop,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // Métricas
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCard(
                        'Temperatura Actual',
                        '${_currentTemperature.toStringAsFixed(1)}°C',
                        Icons.thermostat,
                        Theme.of(context).colorScheme.primary,
                      ),
                      _buildMetricCard(
                        'Humedad Actual',
                        '${_avgHumidity.toStringAsFixed(1)}%',
                        Icons.water_drop,
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      _buildMetricCard(
                        'Alertas Activas',
                        unresolvedAlerts.length.toString(),
                        Icons.warning,
                        unresolvedAlerts.isEmpty ? 
                          Theme.of(context).colorScheme.tertiary : 
                          Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Gráfico
              if (_humidityData.isNotEmpty && _temperatureData.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('🌡 Humedad y Temperatura',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildIntervalSelector(),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % _chartInterval == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('${value.toInt()}h', style: const TextStyle(fontSize: 10)),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 20 == 0) {
                                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: _humidityData.isEmpty ? 23 : _humidityData.last.x,
                          minY: 0,
                          maxY: 80,
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              spots: _humidityData,
                              color: Theme.of(context).colorScheme.tertiary,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true, 
                                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3)
                              ),
                            ),
                            LineChartBarData(
                              isCurved: true,
                              spots: _temperatureData,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true, 
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Pedidos recientes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('📦 Pedidos recientes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: _addNewOrder,
                    tooltip: 'Agregar nuevo pedido',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (recentOrders.isNotEmpty) ...[
                ...recentOrders.map((pedido) => PedidoTile(
                  pedido: pedido,
                  onTap: () => context.push('/pedidos/${pedido['id']}'),
                )),
                if (_recentOrders.length > 3)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      _pageController.jumpToPage(1);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ver todos los pedidos'),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
              ] else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text('No hay pedidos recientes'),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Alertas activas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('⚠️ Alertas activas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Badge(
                    label: Text(unresolvedAlerts.length.toString()),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    child: IconButton(
                      icon: const Icon(Icons.notifications, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                        _pageController.jumpToPage(2);
                      },
                      tooltip: 'Ver todas las alertas',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (unresolvedAlerts.isNotEmpty) 
                ...unresolvedAlerts.take(2).map((alerta) => AlertTile(
                  alerta: alerta,
                  onTap: () => context.push('/alertas/${alerta['id']}'),
                ))
              else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No hay alertas activas',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersPage() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📦 Todos los Pedidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(children: [
              IconButton(icon: const Icon(Icons.add), onPressed: _addNewOrder),
            ]),
          ],
        ),
        const SizedBox(height: 10),

        // Búsqueda
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar pedidos...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),

        // Filtros
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 8.0,
            children: ['Todos', 'Programado', 'Preparando', 'En camino', 'Entregado']
                .map((f) => FilterChip(
                      label: Text(f),
                      selected: _selectedOrderFilter == f,
                      onSelected: (sel) => setState(() => _selectedOrderFilter = sel ? f : 'Todos'),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),

        Text('Mostrando ${_searchedOrders.length} de ${_recentOrders.length} pedidos',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 10),

        Expanded(
          child: _searchedOrders.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No se encontraron pedidos', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadInitialData,
                  child: ListView.builder(
                    itemCount: _searchedOrders.length,
                    itemBuilder: (_, i) => PedidoTile(
                      pedido: _searchedOrders[i],
                      onTap: () => context.push('/pedidos/${_searchedOrders[i]['id']}'),
                    ),
                  ),
                ),
        ),
      ]),
    );
  }

  Widget _buildAlertsPage() {
    final unresolved = _alerts.where((a) => !a['resuelta']).toList();
    final resolved = _alerts.where((a) => a['resuelta']).toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('⚠️ Todas las Alertas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (unresolved.isNotEmpty) ...[
          Row(children: [
            const Text('Alertas Activas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Text(unresolved.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 10),
        ],
        Expanded(
          child: _alerts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No hay alertas registradas', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadInitialData,
                  child: ListView(
                    children: [
                      ...unresolved.map((a) => AlertTile(
                            alerta: a,
                            onTap: () => context.push('/alertas/${a['id']}'),
                            onResolve: () => _resolveAlert(a['id']),
                            onDelete: () => _deleteAlert(a['id']),
                          )),
                      if (resolved.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('Alertas Resueltas',
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: Theme.of(context).colorScheme.tertiary
                            )),
                        const SizedBox(height: 10),
                        ...resolved.map((a) => AlertTile(
                              alerta: a,
                              onTap: () => context.push('/alertas/${a['id']}'),
                              onDelete: () => _deleteAlert(a['id']),
                            )),
                      ],
                    ],
                  ),
                ),
        ),
      ]),
    );
  }

  Widget _buildSettingsPage() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('⚙️ Configuración', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            subtitle: const Text('Configurar alertas y notificaciones'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => _showNotificationSettings(context),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Preferencias de Gráficos'),
            subtitle: const Text('Personalizar visualización de datos'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => _showChartSettings(context),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.data_usage),
            title: const Text('Sincronización de Datos'),
            subtitle: const Text('Configurar frecuencia de actualización'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => _showSyncSettings(context),
          ),
        ),
      ]),
    );
  }

  // Utilidades
  Widget _buildIntervalSelector() {
    return DropdownButton<double>(
      value: _chartInterval,
      icon: const Icon(Icons.timeline),
      items: [1.0, 2.0, 4.0, 6.0, 12.0]
          .map((i) => DropdownMenuItem<double>(value: i, child: Text('Cada ${i.toInt()}h')))
          .toList(),
      onChanged: (v) => setState(() => _chartInterval = v!),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Configuración de Notificaciones'),
        content: const Text('Aquí puedes configurar tus preferencias de notificaciones.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
      ),
    );
  }

  void _showChartSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Configuración de Gráficos'),
        content: const Text('Personaliza la visualización de los gráficos.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
      ),
    );
  }

  void _showSyncSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sincronización de Datos'),
        content: const Text('Configura la frecuencia de actualización de datos.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
      ),
    );
  }
}

// Widgets auxiliares (mantener los mismos que antes)
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class PedidoTile extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final VoidCallback onTap;

  const PedidoTile({
    super.key,
    required this.pedido,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.shopping_bag, color: _getStatusColor(pedido['estado'])),
        title: Text(pedido['cliente']),
        subtitle: Text('${pedido['fecha']} - ${pedido['estado']}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Entregado':
        return Colors.green;
      case 'En camino':
        return Colors.blue;
      case 'Preparando':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class AlertTile extends StatelessWidget {
  final Map<String, dynamic> alerta;
  final VoidCallback onTap;
  final VoidCallback? onResolve;
  final VoidCallback? onDelete;

  const AlertTile({
    super.key,
    required this.alerta,
    required this.onTap,
    this.onResolve,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = alerta['resuelta'] ?? false;
    return Card(
      child: ListTile(
        leading: Icon(
          isResolved ? Icons.check_circle : Icons.warning,
          color: isResolved ? Colors.green : _getAlertColor(alerta['nivel']),
        ),
        title: Text(alerta['mensaje']),
        subtitle: Text('${alerta['fecha']} - Nivel: ${alerta['nivel']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isResolved && onResolve != null)
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: onResolve,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            const Icon(Icons.arrow_forward),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getAlertColor(String nivel) {
    switch (nivel) {
      case 'Alto':
        return Colors.red;
      case 'Medio':
        return Colors.orange;
      default:
        return Colors.yellow;
    }
  }
}