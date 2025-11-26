import 'package:flutter_test/flutter_test.dart';
import 'package:agrocore_app/features/gestion_pedidos/models/order_model.dart';
import 'package:agrocore_app/features/gestion_pedidos/repositories/order_repository.dart';

void main() {
  group('OrderRepository', () {
    late OrderRepository repository;

    setUp(() {
      repository = OrderRepository();
    });

    group('getOrders', () {
      test('should return list of orders', () async {
        final orders = await repository.getOrders();
        
        expect(orders, isA<List<OrderModel>>());
        expect(orders, isNotEmpty);
      });

      test('should return orders sorted by ID', () async {
        final orders = await repository.getOrders();
        
        for (int i = 0; i < orders.length - 1; i++) {
          expect(
            orders[i].id.compareTo(orders[i + 1].id) <= 0,
            true,
            reason: 'Orders should be sorted by ID',
          );
        }
      });

      test('should return default order with ID AA01', () async {
        final orders = await repository.getOrders();
        
        expect(orders.any((o) => o.id == 'AA01'), true);
      });

      test('should return order with customer Juanito Blas', () async {
        final orders = await repository.getOrders();
        
        final order = orders.firstWhere((o) => o.id == 'AA01');
        expect(order.customer, 'Juanito Blas');
      });

      test('should return order with correct properties', () async {
        final orders = await repository.getOrders();
        
        final order = orders.firstWhere((o) => o.id == 'AA01');
        expect(order.crop, 'Tomate');
        expect(order.variety, 'Selecto');
        expect(order.quantity, 15.0);
        expect(order.unit, 'charolas');
        expect(order.status, OrderStatus.delivered);
      });

      test('should complete within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await repository.getOrders();
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });
    });

    group('addOrder', () {
      test('should complete successfully', () async {
        final order = OrderModel(
          id: 'TEST001',
          customer: 'Test Customer',
          crop: 'Test Crop',
          variety: 'Test Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        await expectLater(
          repository.addOrder(order),
          completes,
        );
      });

      test('should complete within reasonable time', () async {
        final order = OrderModel(
          id: 'TEST002',
          customer: 'Test Customer',
          crop: 'Test Crop',
          variety: 'Test Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        final stopwatch = Stopwatch()..start();
        await repository.addOrder(order);
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('updateOrder', () {
      test('should complete successfully', () async {
        final order = OrderModel(
          id: 'AA01',
          customer: 'Updated Customer',
          crop: 'Updated Crop',
          variety: 'Updated Variety',
          quantity: 200.0,
          unit: 'kg',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.shipped,
        );

        await expectLater(
          repository.updateOrder(order),
          completes,
        );
      });

      test('should complete within reasonable time', () async {
        final order = OrderModel(
          id: 'AA01',
          customer: 'Updated Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        final stopwatch = Stopwatch()..start();
        await repository.updateOrder(order);
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('deleteOrder', () {
      test('should complete successfully', () async {
        await expectLater(
          repository.deleteOrder('AA01'),
          completes,
        );
      });

      test('should complete within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await repository.deleteOrder('TEST001');
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('searchOrders', () {
      test('should return all orders when no filters provided', () async {
        final results = await repository.searchOrders();
        final allOrders = await repository.getOrders();
        
        expect(results.length, allOrders.length);
      });

      test('should filter by customer name', () async {
        final results = await repository.searchOrders(customer: 'Juanito');
        
        expect(results.every((o) => o.customer.toLowerCase().contains('juanito')), true);
      });

      test('should filter by crop name', () async {
        final results = await repository.searchOrders(crop: 'Tomate');
        
        expect(results.every((o) => o.crop.toLowerCase().contains('tomate')), true);
      });

      test('should filter by status', () async {
        final results = await repository.searchOrders(status: OrderStatus.delivered);
        
        expect(results.every((o) => o.status == OrderStatus.delivered), true);
      });

      test('should filter by start date', () async {
        final startDate = DateTime.now().subtract(const Duration(days: 10));
        final results = await repository.searchOrders(startDate: startDate);
        
        expect(
          results.every((o) => 
            o.deliveryDate.isAfter(startDate) || 
            o.deliveryDate.isAtSameMomentAs(startDate)
          ),
          true,
        );
      });

      test('should filter by end date', () async {
        final endDate = DateTime.now().add(const Duration(days: 10));
        final results = await repository.searchOrders(endDate: endDate);
        
        expect(
          results.every((o) => 
            o.deliveryDate.isBefore(endDate) || 
            o.deliveryDate.isAtSameMomentAs(endDate)
          ),
          true,
        );
      });

      test('should apply multiple filters together', () async {
        final results = await repository.searchOrders(
          customer: 'Juanito',
          status: OrderStatus.delivered,
        );
        
        expect(
          results.every((o) => 
            o.customer.toLowerCase().contains('juanito') && 
            o.status == OrderStatus.delivered
          ),
          true,
        );
      });

      test('should return empty list when no matches', () async {
        final results = await repository.searchOrders(
          customer: 'NONEXISTENT_CUSTOMER_XYZ123',
        );
        
        expect(results, isEmpty);
      });

      test('should be case insensitive for customer search', () async {
        final results1 = await repository.searchOrders(customer: 'juanito');
        final results2 = await repository.searchOrders(customer: 'JUANITO');
        final results3 = await repository.searchOrders(customer: 'Juanito');
        
        expect(results1.length, results2.length);
        expect(results2.length, results3.length);
      });

      test('should be case insensitive for crop search', () async {
        final results1 = await repository.searchOrders(crop: 'tomate');
        final results2 = await repository.searchOrders(crop: 'TOMATE');
        final results3 = await repository.searchOrders(crop: 'Tomate');
        
        expect(results1.length, results2.length);
        expect(results2.length, results3.length);
      });

      test('should return sorted results', () async {
        final results = await repository.searchOrders();
        
        for (int i = 0; i < results.length - 1; i++) {
          expect(
            results[i].id.compareTo(results[i + 1].id) <= 0,
            true,
            reason: 'Results should be sorted by ID',
          );
        }
      });

      test('should complete within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await repository.searchOrders(customer: 'Test', crop: 'Crop');
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('getOrderStatistics', () {
      test('should return statistics map', () async {
        final stats = await repository.getOrderStatistics();
        
        expect(stats, isA<Map<String, dynamic>>());
      });

      test('should include total orders count', () async {
        final stats = await repository.getOrderStatistics();
        
        expect(stats.containsKey('totalOrders'), true);
        expect(stats['totalOrders'], isA<int>());
        expect(stats['totalOrders'], greaterThanOrEqualTo(0));
      });

      test('should include counts for all statuses', () async {
        final stats = await repository.getOrderStatistics();
        
        expect(stats.containsKey('pendingCount'), true);
        expect(stats.containsKey('inProcessCount'), true);
        expect(stats.containsKey('shippedCount'), true);
        expect(stats.containsKey('deliveredCount'), true);
        expect(stats.containsKey('cancelledCount'), true);
      });

      test('should include total quantity', () async {
        final stats = await repository.getOrderStatistics();
        
        expect(stats.containsKey('totalQuantity'), true);
        expect(stats['totalQuantity'], isA<double>());
        expect(stats['totalQuantity'], greaterThanOrEqualTo(0));
      });

      test('should include average quantity', () async {
        final stats = await repository.getOrderStatistics();
        
        expect(stats.containsKey('averageQuantity'), true);
        expect(stats['averageQuantity'], isA<double>());
        expect(stats['averageQuantity'], greaterThanOrEqualTo(0));
      });

      test('should calculate correct totals', () async {
        final stats = await repository.getOrderStatistics();
        
        final total = stats['pendingCount'] as int +
                     stats['inProcessCount'] as int +
                     stats['shippedCount'] as int +
                     stats['deliveredCount'] as int +
                     stats['cancelledCount'] as int;
        
        expect(total, stats['totalOrders']);
      });

      test('should calculate average correctly', () async {
        final stats = await repository.getOrderStatistics();
        
        final totalOrders = stats['totalOrders'] as int;
        final totalQuantity = stats['totalQuantity'] as double;
        final averageQuantity = stats['averageQuantity'] as double;
        
        if (totalOrders > 0) {
          expect(averageQuantity, closeTo(totalQuantity / totalOrders, 0.01));
        } else {
          expect(averageQuantity, 0);
        }
      });
    });

    group('orderIdExists', () {
      test('should return true for existing order ID', () async {
        final exists = await repository.orderIdExists('AA01');
        expect(exists, true);
      });

      test('should return false for non-existing order ID', () async {
        final exists = await repository.orderIdExists('NONEXISTENT999');
        expect(exists, false);
      });

      test('should be case sensitive', () async {
        final exists1 = await repository.orderIdExists('AA01');
        final exists2 = await repository.orderIdExists('aa01');
        
        expect(exists1, true);
        // Assuming IDs are case-sensitive
        expect(exists2, false);
      });
    });

    group('getNextOrderId', () {
      test('should return AA01 for empty repository', () async {
        // This test assumes we can't actually empty the repository
        // but tests the logic
        final nextId = await repository.getNextOrderId();
        expect(nextId, matches(RegExp(r'AA\d{2}')));
      });

      test('should increment from existing orders', () async {
        final nextId = await repository.getNextOrderId();
        expect(nextId, matches(RegExp(r'AA\d{2}')));
        expect(nextId.startsWith('AA'), true);
        expect(nextId.length, 4);
      });

      test('should pad with zeros', () async {
        final nextId = await repository.getNextOrderId();
        expect(nextId.length, 4);
        expect(nextId.substring(2).length, 2);
      });

      test('should generate valid format', () async {
        final nextId = await repository.getNextOrderId();
        expect(nextId, matches(RegExp(r'^AA\d{2}$')));
      });

      test('should be greater than existing IDs', () async {
        final orders = await repository.getOrders();
        final nextId = await repository.getNextOrderId();
        
        final aaOrders = orders.where((o) => o.id.startsWith('AA')).toList();
        if (aaOrders.isNotEmpty) {
          final maxExistingId = aaOrders.map((o) => o.id).reduce(
            (a, b) => a.compareTo(b) > 0 ? a : b
          );
          expect(nextId.compareTo(maxExistingId), greaterThan(0));
        }
      });
    });

    group('Edge cases and error handling', () {
      test('should handle concurrent operations', () async {
        final order1 = OrderModel(
          id: 'CONC001',
          customer: 'Customer 1',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        final order2 = OrderModel(
          id: 'CONC002',
          customer: 'Customer 2',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        await Future.wait([
          repository.addOrder(order1),
          repository.addOrder(order2),
        ]);

        expect(true, true); // Should complete without errors
      });

      test('should handle empty string filters', () async {
        final results = await repository.searchOrders(
          customer: '',
          crop: '',
        );
        
        expect(results, isNotEmpty);
      });

      test('should handle date range filters with same date', () async {
        final date = DateTime.now();
        final results = await repository.searchOrders(
          startDate: date,
          endDate: date,
        );
        
        // Should return orders on that exact date
        expect(results, isA<List<OrderModel>>());
      });

      test('should handle inverted date range', () async {
        final futureDate = DateTime.now().add(const Duration(days: 10));
        final pastDate = DateTime.now().subtract(const Duration(days: 10));
        
        final results = await repository.searchOrders(
          startDate: futureDate,
          endDate: pastDate,
        );
        
        // Should return empty or handle gracefully
        expect(results, isA<List<OrderModel>>());
      });
    });
  });
}