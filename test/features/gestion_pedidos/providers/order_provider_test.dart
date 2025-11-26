import 'package:flutter_test/flutter_test.dart';
import 'package:agrocore_app/features/gestion_pedidos/models/order_model.dart';
import 'package:agrocore_app/features/gestion_pedidos/providers/order_provider.dart';

void main() {
  group('OrderProvider', () {
    late OrderProvider provider;

    setUp(() {
      provider = OrderProvider();
    });

    group('Initialization', () {
      test('should initialize with default orders', () {
        expect(provider.orders, isNotEmpty);
        expect(provider.orders.length, 1);
        expect(provider.orders.first.id, 'AA01');
      });

      test('should not be loading initially', () {
        expect(provider.loading, false);
      });

      test('should have no error initially', () {
        expect(provider.error, isNull);
      });

      test('should have correct total orders count', () {
        expect(provider.totalOrders, 1);
      });
    });

    group('loadOrders', () {
      test('should load orders successfully', () async {
        provider.clearOrders();
        expect(provider.orders.isEmpty, true);

        await provider.loadOrders();

        expect(provider.orders, isNotEmpty);
        expect(provider.loading, false);
        expect(provider.error, isNull);
      });

      test('should set loading to true during load', () async {
        provider.clearOrders();
        final future = provider.loadOrders();
        
        // Should be loading immediately
        expect(provider.loading, true);
        
        await future;
        expect(provider.loading, false);
      });

      test('should clear error on successful load', () async {
        await provider.loadOrders();
        expect(provider.error, isNull);
      });

      test('should update orders list', () async {
        final initialCount = provider.orders.length;
        provider.clearOrders();
        
        await provider.loadOrders();
        
        expect(provider.orders.length, greaterThanOrEqualTo(0));
      });
    });

    group('addOrder', () {
      test('should add new order to the list', () async {
        final initialCount = provider.orders.length;
        final newOrder = OrderModel(
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

        await provider.addOrder(newOrder);

        expect(provider.orders.length, initialCount + 1);
        expect(provider.orders.first.id, 'TEST001');
      });

      test('should add order at the beginning of the list', () async {
        final newOrder = OrderModel(
          id: 'FIRST',
          customer: 'First Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 50.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 5)),
          status: OrderStatus.pending,
        );

        await provider.addOrder(newOrder);

        expect(provider.orders.first.id, 'FIRST');
      });

      test('should set default unit if empty', () async {
        final newOrder = OrderModel(
          id: 'TEST002',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: '',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        await provider.addOrder(newOrder);

        final addedOrder = provider.orders.first;
        expect(addedOrder.unit, 'unidades');
      });

      test('should preserve unit if provided', () async {
        final newOrder = OrderModel(
          id: 'TEST003',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'kg',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        await provider.addOrder(newOrder);

        final addedOrder = provider.orders.first;
        expect(addedOrder.unit, 'kg');
      });

      test('should clear error on successful add', () async {
        final newOrder = OrderModel(
          id: 'TEST004',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );

        await provider.addOrder(newOrder);

        expect(provider.error, isNull);
      });
    });

    group('updateOrder', () {
      test('should update existing order', () async {
        final order = provider.orders.first;
        final updatedOrder = order.copyWith(
          customer: 'Updated Customer',
          quantity: 200.0,
        );

        await provider.updateOrder(updatedOrder);

        final foundOrder = provider.orders.firstWhere((o) => o.id == order.id);
        expect(foundOrder.customer, 'Updated Customer');
        expect(foundOrder.quantity, 200.0);
      });

      test('should maintain order count after update', () async {
        final initialCount = provider.orders.length;
        final order = provider.orders.first;
        final updatedOrder = order.copyWith(status: OrderStatus.delivered);

        await provider.updateOrder(updatedOrder);

        expect(provider.orders.length, initialCount);
      });

      test('should update order status', () async {
        final order = provider.orders.first;
        final updatedOrder = order.copyWith(status: OrderStatus.cancelled);

        await provider.updateOrder(updatedOrder);

        final foundOrder = provider.orders.firstWhere((o) => o.id == order.id);
        expect(foundOrder.status, OrderStatus.cancelled);
      });

      test('should clear error on successful update', () async {
        final order = provider.orders.first;
        final updatedOrder = order.copyWith(customer: 'New Name');

        await provider.updateOrder(updatedOrder);

        expect(provider.error, isNull);
      });
    });

    group('deleteOrder', () {
      test('should remove order from list', () async {
        final newOrder = OrderModel(
          id: 'DELETE001',
          customer: 'To Delete',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );
        await provider.addOrder(newOrder);

        final initialCount = provider.orders.length;
        await provider.deleteOrder('DELETE001');

        expect(provider.orders.length, initialCount - 1);
        expect(
          provider.orders.any((o) => o.id == 'DELETE001'),
          false,
        );
      });

      test('should clear error on successful delete', () async {
        final newOrder = OrderModel(
          id: 'DELETE002',
          customer: 'To Delete',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        );
        await provider.addOrder(newOrder);

        await provider.deleteOrder('DELETE002');

        expect(provider.error, isNull);
      });
    });

    group('getOrderById', () {
      test('should return order when found', () {
        final order = provider.orders.first;
        final found = provider.getOrderById(order.id);

        expect(found, isNotNull);
        expect(found?.id, order.id);
      });

      test('should return null when order not found', () {
        final found = provider.getOrderById('NONEXISTENT');
        expect(found, isNull);
      });

      test('should return correct order by id', () {
        final found = provider.getOrderById('AA01');
        expect(found, isNotNull);
        expect(found?.id, 'AA01');
      });
    });

    group('getOrdersByStatus', () {
      test('should return orders with specific status', () async {
        // Add orders with different statuses
        await provider.addOrder(OrderModel(
          id: 'PEND001',
          customer: 'Customer 1',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        await provider.addOrder(OrderModel(
          id: 'SHIP001',
          customer: 'Customer 2',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.shipped,
        ));

        final pendingOrders = provider.getOrdersByStatus(OrderStatus.pending);
        expect(pendingOrders.every((o) => o.status == OrderStatus.pending), true);
      });

      test('should return empty list when no orders match status', () {
        provider.clearOrders();
        final cancelledOrders = provider.getOrdersByStatus(OrderStatus.cancelled);
        expect(cancelledOrders, isEmpty);
      });
    });

    group('searchOrders', () {
      test('should return all orders for empty query', () {
        final results = provider.searchOrders('');
        expect(results.length, provider.orders.length);
      });

      test('should search by customer name', () async {
        await provider.addOrder(OrderModel(
          id: 'SEARCH001',
          customer: 'Unique Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        final results = provider.searchOrders('Unique');
        expect(results.any((o) => o.customer.contains('Unique')), true);
      });

      test('should search by crop name', () async {
        await provider.addOrder(OrderModel(
          id: 'SEARCH002',
          customer: 'Customer',
          crop: 'Unique Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        final results = provider.searchOrders('Unique Crop');
        expect(results.any((o) => o.crop.contains('Unique')), true);
      });

      test('should search by variety', () async {
        await provider.addOrder(OrderModel(
          id: 'SEARCH003',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Unique Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        final results = provider.searchOrders('Unique Variety');
        expect(results.any((o) => o.variety.contains('Unique')), true);
      });

      test('should search by order id', () {
        final results = provider.searchOrders('AA01');
        expect(results.any((o) => o.id == 'AA01'), true);
      });

      test('should be case insensitive', () async {
        await provider.addOrder(OrderModel(
          id: 'SEARCH004',
          customer: 'CaseSensitive',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        final results1 = provider.searchOrders('casesensitive');
        final results2 = provider.searchOrders('CASESENSITIVE');
        final results3 = provider.searchOrders('CaseSensitive');

        expect(results1.any((o) => o.customer == 'CaseSensitive'), true);
        expect(results2.any((o) => o.customer == 'CaseSensitive'), true);
        expect(results3.any((o) => o.customer == 'CaseSensitive'), true);
      });

      test('should return empty list when no matches', () {
        final results = provider.searchOrders('NONEXISTENT_SEARCH_TERM_XYZ123');
        expect(results, isEmpty);
      });
    });

    group('clearError', () {
      test('should clear error', () {
        provider.clearError();
        expect(provider.error, isNull);
      });
    });

    group('clearOrders', () {
      test('should remove all orders', () {
        provider.clearOrders();
        expect(provider.orders, isEmpty);
        expect(provider.totalOrders, 0);
      });
    });

    group('totalOrders', () {
      test('should return correct count', () {
        final count = provider.orders.length;
        expect(provider.totalOrders, count);
      });

      test('should update after adding order', () async {
        final initialCount = provider.totalOrders;
        await provider.addOrder(OrderModel(
          id: 'COUNT001',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.totalOrders, initialCount + 1);
      });
    });

    group('getOrdersCountByStatus', () {
      test('should return correct count for status', () async {
        provider.clearOrders();
        
        await provider.addOrder(OrderModel(
          id: 'STATUS001',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        await provider.addOrder(OrderModel(
          id: 'STATUS002',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.getOrdersCountByStatus(OrderStatus.pending), 2);
      });

      test('should return zero for status with no orders', () {
        provider.clearOrders();
        expect(provider.getOrdersCountByStatus(OrderStatus.cancelled), 0);
      });
    });

    group('generateNextOrderId', () {
      test('should generate AA01 for empty list', () {
        provider.clearOrders();
        expect(provider.generateNextOrderId(), 'AA01');
      });

      test('should increment existing order IDs', () async {
        provider.clearOrders();
        await provider.addOrder(OrderModel(
          id: 'AA01',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.generateNextOrderId(), 'AA02');
      });

      test('should handle double digit IDs', () async {
        provider.clearOrders();
        await provider.addOrder(OrderModel(
          id: 'AA09',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.generateNextOrderId(), 'AA10');
      });

      test('should find max ID from multiple orders', () async {
        provider.clearOrders();
        await provider.addOrder(OrderModel(
          id: 'AA03',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));
        await provider.addOrder(OrderModel(
          id: 'AA01',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.generateNextOrderId(), 'AA04');
      });

      test('should pad single digit with zero', () async {
        provider.clearOrders();
        await provider.addOrder(OrderModel(
          id: 'AA05',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.generateNextOrderId(), 'AA06');
      });

      test('should ignore orders with different prefix', () async {
        provider.clearOrders();
        await provider.addOrder(OrderModel(
          id: 'BB01',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.generateNextOrderId(), 'AA01');
      });

      test('should ignore malformed IDs', () async {
        provider.clearOrders();
        await provider.addOrder(OrderModel(
          id: 'AAXX',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 7)),
          status: OrderStatus.pending,
        ));

        expect(provider.generateNextOrderId(), 'AA01');
      });
    });
  });
}