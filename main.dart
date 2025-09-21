import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xFF2A2A40),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Simulador de datos en tiempo real
  Timer? _timer;
  final Random _random = Random();
  
  // Datos iniciales
  int _activeOrders = 12;
  int _upcomingDeliveries = 5;
  double _avgHumidity = 68.0;
  double _currentTemperature = 24.5;
  
  List<FlSpot> _humidityData = [];
  List<FlSpot> _temperatureData = [];
  
  final List<Map<String, dynamic>> _recentOrders = [
    {"cliente": "Supermercado Oaxaca", "fecha": "Hoy 10:00 AM", "estado": "En camino"},
    {"cliente": "Restaurante Istmo", "fecha": "Hoy 01:30 PM", "estado": "Preparando"},
    {"cliente": "Mercado Juárez", "fecha": "Mañana 09:00 AM", "estado": "Programado"},
  ];
  
  final List<Map<String, dynamic>> _alerts = [
    {"mensaje": "Humedad baja en Invernadero 2", "nivel": "Alto"},
    {"mensaje": "Sensor S011 sin reporte", "nivel": "Medio"},
  ];

  // Estado de conexión a BD
  bool _isConnected = true;
  String _connectionStatus = "Conectado";

  @override
  void initState() {
    super.initState();
    // Inicializar datos del gráfico
    _initializeChartData();
    
    // Simular actualizaciones en tiempo real cada 3 segundos
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateData();
    });

    // Simular cambios de conexión
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _simulateConnectionChanges();
    });
  }

  void _initializeChartData() {
    // Generar datos iniciales para las últimas 24 horas
    final now = DateTime.now();
    for (int i = 0; i < 24; i++) {
      final hour = now.subtract(Duration(hours: 23 - i));
      _humidityData.add(FlSpot(
        i.toDouble(), 
        60 + _random.nextDouble() * 20 // Humedad entre 60-80%
      ));
      _temperatureData.add(FlSpot(
        i.toDouble(), 
        18 + _random.nextDouble() * 12 // Temperatura entre 18-30°C
      ));
    }
  }

  void _updateData() {
    if (!_isConnected) return;
    
    setState(() {
      // Actualizar KPIs con valores aleatorios (simulando datos reales)
      _activeOrders = 10 + _random.nextInt(5);
      _upcomingDeliveries = 3 + _random.nextInt(4);
      _avgHumidity = 65 + _random.nextDouble() * 10;
      _currentTemperature = 18 + _random.nextDouble() * 12;
      
      // Actualizar datos del gráfico (eliminar el punto más antiguo y agregar uno nuevo)
      if (_humidityData.length >= 24) {
        _humidityData.removeAt(0);
        _temperatureData.removeAt(0);
      }
      
      // Agregar nuevo dato con el timestamp actual
      final lastX = _humidityData.isNotEmpty ? _humidityData.last.x + 1 : 24;
      _humidityData.add(FlSpot(lastX, 60 + _random.nextDouble() * 20));
      _temperatureData.add(FlSpot(lastX, 18 + _random.nextDouble() * 12));
      
      // Simular ocasionalmente nuevas alertas (5% de probabilidad)
      if (_random.nextDouble() < 0.05) {
        List<String> alertTypes = [
          "Humedad crítica en Invernadero ${_random.nextInt(5) + 1}",
          "Temperatura fuera de rango en Zona ${_random.nextInt(3) + 1}",
          "Sensor S${_random.nextInt(100).toString().padLeft(3, '0')} sin reporte",
          "Riego automático activado en Sector ${_random.nextInt(8) + 1}",
          "Necesidad de fertilizante detectada"
        ];
        
        List<String> levels = ["Bajo", "Medio", "Alto"];
        
        _alerts.add({
          "mensaje": alertTypes[_random.nextInt(alertTypes.length)],
          "nivel": levels[_random.nextInt(levels.length)]
        });
      }
      
      // Simular actualización de estado de pedidos
      if (_random.nextDouble() < 0.1 && _recentOrders.isNotEmpty) {
        int index = _random.nextInt(_recentOrders.length);
        List<String> estados = ["Programado", "Preparando", "En camino", "Entregado"];
        _recentOrders[index]["estado"] = estados[_random.nextInt(estados.length)];
      }
    });
  }

  void _simulateConnectionChanges() {
    // Simular cambios de conexión (10% de probabilidad de desconexión)
    if (_random.nextDouble() < 0.1) {
      setState(() {
        _isConnected = !_isConnected;
        _connectionStatus = _isConnected ? "Conectado" : "Desconectado";
        
        if (!_isConnected) {
          _alerts.add({
            "mensaje": "Pérdida de conexión con el servidor",
            "nivel": "Alto"
          });
        } else {
          _alerts.add({
            "mensaje": "Conexión restablecida con el servidor",
            "nivel": "Medio"
          });
        }
      });
    }
  }

  void _addNewOrder() {
    setState(() {
      List<String> clientes = [
        "Mercado Central",
        "Tienda Orgánica",
        "Distribuidora Verde",
        "Supermercado Ecológico",
        "Restaurante La Huerta"
      ];
      
      List<String> horas = [
        "Hoy 10:00 AM", 
        "Hoy 02:30 PM", 
        "Mañana 09:00 AM", 
        "Mañana 11:45 AM"
      ];
      
      _recentOrders.insert(0, {
        "cliente": clientes[_random.nextInt(clientes.length)],
        "fecha": horas[_random.nextInt(horas.length)],
        "estado": "Programado"
      });
    });
    
    // Mostrar notificación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Nuevo pedido agregado a la base de datos"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Agricultor - Tiempo Real"),
        backgroundColor: const Color(0xFF12121D),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateData,
            tooltip: "Actualizar datos",
          ),
          IconButton(
            icon: Icon(_isConnected ? Icons.cloud_done : Icons.cloud_off),
            onPressed: () {
              setState(() {
                _isConnected = !_isConnected;
                _connectionStatus = _isConnected ? "Conectado" : "Desconectado";
              });
            },
            tooltip: _connectionStatus,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de conexión
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  _connectionStatus,
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            /// KPIs en tiempo real
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KpiCard(
                  title: "Pedidos activos", 
                  value: _activeOrders.toString(),
                  icon: Icons.shopping_cart,
                ),
                KpiCard(
                  title: "Próximas entregas", 
                  value: _upcomingDeliveries.toString(),
                  icon: Icons.local_shipping,
                ),
                KpiCard(
                  title: "Humedad Prom.", 
                  value: "${_avgHumidity.toStringAsFixed(1)}%",
                  icon: Icons.water_drop,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Temperatura actual
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCard(
                      "Temperatura Actual",
                      "${_currentTemperature.toStringAsFixed(1)}°C",
                      Icons.thermostat,
                      Colors.orangeAccent,
                    ),
                    _buildMetricCard(
                      "Humedad Actual",
                      "${(_avgHumidity + _random.nextDouble() * 5 - 2.5).toStringAsFixed(1)}%",
                      Icons.water_drop,
                      Colors.tealAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Gráfico humedad y temperatura en tiempo real
            const Text("🌡 Humedad y Temperatura últimas 24h",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      minX: 0,
                      maxX: _humidityData.isNotEmpty ? _humidityData.last.x : 24,
                      minY: 0,
                      maxY: 80,
                      lineBarsData: [
                        /// Línea de Humedad
                        LineChartBarData(
                          isCurved: true,
                          spots: _humidityData,
                          color: Colors.tealAccent,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: true, color: Colors.tealAccent.withOpacity(0.1)),
                        ),
                        /// Línea de Temperatura
                        LineChartBarData(
                          isCurved: true,
                          spots: _temperatureData,
                          color: Colors.orangeAccent,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: true, color: Colors.orangeAccent.withOpacity(0.1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Pedidos recientes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("📦 Pedidos recientes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: _addNewOrder,
                  tooltip: "Agregar nuevo pedido",
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: _recentOrders.length,
                itemBuilder: (context, index) {
                  return PedidoTile(
                    cliente: _recentOrders[index]['cliente']!,
                    fecha: _recentOrders[index]['fecha']!,
                    estado: _recentOrders[index]['estado']!,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Alertas activas
            const Text("⚠️ Alertas activas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  return AlertTile(
                    mensaje: _alerts[index]['mensaje']!,
                    nivel: _alerts[index]['nivel']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Botón para simular conexión a base de datos
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewOrder,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
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
}

/// Widgets personalizados

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  
  const KpiCard({
    super.key, 
    required this.title, 
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: Colors.tealAccent),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent)),
            ],
          ),
        ),
      ),
    );
  }
}

class PedidoTile extends StatelessWidget {
  final String cliente;
  final String fecha;
  final String estado;
  
  const PedidoTile({
    super.key, 
    required this.cliente, 
    required this.fecha,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    Color estadoColor;
    
    switch (estado) {
      case "Programado":
        estadoColor = Colors.blue;
        break;
      case "Preparando":
        estadoColor = Colors.orange;
        break;
      case "En camino":
        estadoColor = Colors.green;
        break;
      case "Entregado":
        estadoColor = Colors.grey;
        break;
      default:
        estadoColor = Colors.white;
    }
    
    return Card(
      child: ListTile(
        title: Text(cliente),
        subtitle: Text("Entrega: $fecha"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, color: Colors.tealAccent),
            const SizedBox(height: 4),
            Text(estado, style: TextStyle(color: estadoColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  final String mensaje;
  final String nivel;
  
  const AlertTile({
    super.key, 
    required this.mensaje, 
    required this.nivel,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    
    switch (nivel) {
      case "Alto":
        color = Colors.redAccent;
        break;
      case "Medio":
        color = Colors.orangeAccent;
        break;
      case "Bajo":
        color = Colors.yellowAccent;
        break;
      default:
        color = Colors.white;
    }
    
    return Card(
      color: const Color(0xFF402A2A),
      child: ListTile(
        leading: Icon(Icons.warning, color: color),
        title: Text(mensaje, style: const TextStyle(color: Colors.white, fontSize: 14)),
        subtitle: Text("Nivel: $nivel", style: TextStyle(color: color, fontSize: 12)),
      ),
    );
  }
}
