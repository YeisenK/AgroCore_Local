import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agrocore_app/features/gestion_pedidos/models/order_model.dart';

void main() {
  group('OrderModel', () {
    late DateTime testOrderDate;
    late DateTime testDeliveryDate;

    setUp(() {
      testOrderDate = DateTime(2024, 1, 15);
      testDeliveryDate = DateTime(2024, 1, 22);
    });

    group('Constructor', () {
      test('should create OrderModel with all required fields', () {
        final order = OrderModel(
          id: 'TEST001',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        expect(order.id, 'TEST001');
        expect(order.customer, 'Test Customer');
        expect(order.crop, 'Tomato');
        expect(order.variety, 'Cherry');
        expect(order.quantity, 100.0);
        expect(order.unit, 'units');
        expect(order.orderDate, testOrderDate);
        expect(order.deliveryDate, testDeliveryDate);
        expect(order.status, OrderStatus.pending);
        expect(order.notes, isNull);
      });

      test('should create OrderModel with optional notes field', () {
        final order = OrderModel(
          id: 'TEST002',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 50.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.inProcess,
          notes: 'Special handling required',
        );

        expect(order.notes, 'Special handling required');
      });
    });

    group('statusText', () {
      test('should return correct text for pending status', () {
        final order = OrderModel(
          id: 'TEST003',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        expect(order.statusText, 'Pendiente');
      });

      test('should return correct text for inProcess status', () {
        final order = OrderModel(
          id: 'TEST004',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.inProcess,
        );

        expect(order.statusText, 'En Proceso');
      });

      test('should return correct text for shipped status', () {
        final order = OrderModel(
          id: 'TEST005',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.shipped,
        );

        expect(order.statusText, 'Enviado');
      });

      test('should return correct text for delivered status', () {
        final order = OrderModel(
          id: 'TEST006',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.delivered,
        );

        expect(order.statusText, 'Entregado');
      });

      test('should return correct text for cancelled status', () {
        final order = OrderModel(
          id: 'TEST007',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.cancelled,
        );

        expect(order.statusText, 'Cancelado');
      });
    });

    group('statusColor', () {
      test('should return orange color for pending status', () {
        final order = OrderModel(
          id: 'TEST008',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        expect(order.statusColor, Colors.orange);
      });

      test('should return purple color for inProcess status', () {
        final order = OrderModel(
          id: 'TEST009',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.inProcess,
        );

        expect(order.statusColor, Colors.purple);
      });

      test('should return indigo color for shipped status', () {
        final order = OrderModel(
          id: 'TEST010',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.shipped,
        );

        expect(order.statusColor, Colors.indigo);
      });

      test('should return green color for delivered status', () {
        final order = OrderModel(
          id: 'TEST011',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.delivered,
        );

        expect(order.statusColor, Colors.green);
      });

      test('should return red color for cancelled status', () {
        final order = OrderModel(
          id: 'TEST012',
          customer: 'Test Customer',
          crop: 'Tomato',
          variety: 'Cherry',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.cancelled,
        );

        expect(order.statusColor, Colors.red);
      });
    });

    group('copyWith', () {
      late OrderModel originalOrder;

      setUp(() {
        originalOrder = OrderModel(
          id: 'ORIG001',
          customer: 'Original Customer',
          crop: 'Original Crop',
          variety: 'Original Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
          notes: 'Original notes',
        );
      });

      test('should return identical copy when no parameters provided', () {
        final copied = originalOrder.copyWith();

        expect(copied.id, originalOrder.id);
        expect(copied.customer, originalOrder.customer);
        expect(copied.crop, originalOrder.crop);
        expect(copied.variety, originalOrder.variety);
        expect(copied.quantity, originalOrder.quantity);
        expect(copied.unit, originalOrder.unit);
        expect(copied.orderDate, originalOrder.orderDate);
        expect(copied.deliveryDate, originalOrder.deliveryDate);
        expect(copied.status, originalOrder.status);
        expect(copied.notes, originalOrder.notes);
      });

      test('should update only id when provided', () {
        final copied = originalOrder.copyWith(id: 'NEW001');

        expect(copied.id, 'NEW001');
        expect(copied.customer, originalOrder.customer);
        expect(copied.crop, originalOrder.crop);
      });

      test('should update only customer when provided', () {
        final copied = originalOrder.copyWith(customer: 'New Customer');

        expect(copied.customer, 'New Customer');
        expect(copied.id, originalOrder.id);
        expect(copied.crop, originalOrder.crop);
      });

      test('should update only status when provided', () {
        final copied = originalOrder.copyWith(status: OrderStatus.delivered);

        expect(copied.status, OrderStatus.delivered);
        expect(copied.id, originalOrder.id);
        expect(copied.customer, originalOrder.customer);
      });

      test('should update multiple fields when provided', () {
        final newDeliveryDate = DateTime(2024, 2, 1);
        final copied = originalOrder.copyWith(
          customer: 'Updated Customer',
          quantity: 200.0,
          deliveryDate: newDeliveryDate,
          status: OrderStatus.shipped,
        );

        expect(copied.customer, 'Updated Customer');
        expect(copied.quantity, 200.0);
        expect(copied.deliveryDate, newDeliveryDate);
        expect(copied.status, OrderStatus.shipped);
        expect(copied.id, originalOrder.id);
        expect(copied.crop, originalOrder.crop);
      });

      test('should update notes to null', () {
        final copied = originalOrder.copyWith(notes: null);

        expect(copied.notes, isNull);
      });

      test('should update notes to new value', () {
        final copied = originalOrder.copyWith(notes: 'Updated notes');

        expect(copied.notes, 'Updated notes');
      });
    });

    group('toJson', () {
      test('should convert OrderModel to JSON correctly', () {
        final order = OrderModel(
          id: 'JSON001',
          customer: 'JSON Customer',
          crop: 'JSON Crop',
          variety: 'JSON Variety',
          quantity: 150.5,
          unit: 'kg',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.inProcess,
          notes: 'Test notes',
        );

        final json = order.toJson();

        expect(json['id'], 'JSON001');
        expect(json['customer'], 'JSON Customer');
        expect(json['crop'], 'JSON Crop');
        expect(json['variety'], 'JSON Variety');
        expect(json['quantity'], 150.5);
        expect(json['unit'], 'kg');
        expect(json['orderDate'], testOrderDate.toIso8601String());
        expect(json['deliveryDate'], testDeliveryDate.toIso8601String());
        expect(json['status'], 'inProcess');
        expect(json['notes'], 'Test notes');
      });

      test('should handle null notes in JSON', () {
        final order = OrderModel(
          id: 'JSON002',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        final json = order.toJson();

        expect(json['notes'], isNull);
      });

      test('should serialize all OrderStatus values correctly', () {
        final statuses = [
          OrderStatus.pending,
          OrderStatus.inProcess,
          OrderStatus.shipped,
          OrderStatus.delivered,
          OrderStatus.cancelled,
        ];

        for (final status in statuses) {
          final order = OrderModel(
            id: 'TEST',
            customer: 'Customer',
            crop: 'Crop',
            variety: 'Variety',
            quantity: 100.0,
            unit: 'units',
            orderDate: testOrderDate,
            deliveryDate: testDeliveryDate,
            status: status,
          );

          final json = order.toJson();
          expect(json['status'], status.name);
        }
      });
    });

    group('fromJson', () {
      test('should create OrderModel from valid JSON', () {
        final json = {
          'id': 'FROM001',
          'customer': 'From JSON Customer',
          'crop': 'From JSON Crop',
          'variety': 'From JSON Variety',
          'quantity': 200.0,
          'unit': 'liters',
          'orderDate': testOrderDate.toIso8601String(),
          'deliveryDate': testDeliveryDate.toIso8601String(),
          'status': 'shipped',
          'notes': 'From JSON notes',
        };

        final order = OrderModel.fromJson(json);

        expect(order.id, 'FROM001');
        expect(order.customer, 'From JSON Customer');
        expect(order.crop, 'From JSON Crop');
        expect(order.variety, 'From JSON Variety');
        expect(order.quantity, 200.0);
        expect(order.unit, 'liters');
        expect(order.orderDate, testOrderDate);
        expect(order.deliveryDate, testDeliveryDate);
        expect(order.status, OrderStatus.shipped);
        expect(order.notes, 'From JSON notes');
      });

      test('should handle integer quantity in JSON', () {
        final json = {
          'id': 'FROM002',
          'customer': 'Customer',
          'crop': 'Crop',
          'variety': 'Variety',
          'quantity': 100,
          'unit': 'units',
          'orderDate': testOrderDate.toIso8601String(),
          'deliveryDate': testDeliveryDate.toIso8601String(),
          'status': 'pending',
        };

        final order = OrderModel.fromJson(json);

        expect(order.quantity, 100.0);
        expect(order.quantity, isA<double>());
      });

      test('should handle null notes in JSON', () {
        final json = {
          'id': 'FROM003',
          'customer': 'Customer',
          'crop': 'Crop',
          'variety': 'Variety',
          'quantity': 100.0,
          'unit': 'units',
          'orderDate': testOrderDate.toIso8601String(),
          'deliveryDate': testDeliveryDate.toIso8601String(),
          'status': 'pending',
          'notes': null,
        };

        final order = OrderModel.fromJson(json);

        expect(order.notes, isNull);
      });

      test('should default to pending status for invalid status value', () {
        final json = {
          'id': 'FROM004',
          'customer': 'Customer',
          'crop': 'Crop',
          'variety': 'Variety',
          'quantity': 100.0,
          'unit': 'units',
          'orderDate': testOrderDate.toIso8601String(),
          'deliveryDate': testDeliveryDate.toIso8601String(),
          'status': 'invalid_status',
        };

        final order = OrderModel.fromJson(json);

        expect(order.status, OrderStatus.pending);
      });

      test('should parse all valid OrderStatus values', () {
        final statusMap = {
          'pending': OrderStatus.pending,
          'inProcess': OrderStatus.inProcess,
          'shipped': OrderStatus.shipped,
          'delivered': OrderStatus.delivered,
          'cancelled': OrderStatus.cancelled,
        };

        statusMap.forEach((statusString, expectedStatus) {
          final json = {
            'id': 'TEST',
            'customer': 'Customer',
            'crop': 'Crop',
            'variety': 'Variety',
            'quantity': 100.0,
            'unit': 'units',
            'orderDate': testOrderDate.toIso8601String(),
            'deliveryDate': testDeliveryDate.toIso8601String(),
            'status': statusString,
          };

          final order = OrderModel.fromJson(json);
          expect(order.status, expectedStatus);
        });
      });
    });

    group('JSON roundtrip', () {
      test('should maintain data integrity through toJson and fromJson', () {
        final original = OrderModel(
          id: 'ROUND001',
          customer: 'Roundtrip Customer',
          crop: 'Roundtrip Crop',
          variety: 'Roundtrip Variety',
          quantity: 99.99,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.delivered,
          notes: 'Roundtrip notes',
        );

        final json = original.toJson();
        final restored = OrderModel.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.customer, original.customer);
        expect(restored.crop, original.crop);
        expect(restored.variety, original.variety);
        expect(restored.quantity, original.quantity);
        expect(restored.unit, original.unit);
        expect(restored.orderDate, original.orderDate);
        expect(restored.deliveryDate, original.deliveryDate);
        expect(restored.status, original.status);
        expect(restored.notes, original.notes);
      });

      test('should handle roundtrip with null notes', () {
        final original = OrderModel(
          id: 'ROUND002',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        final json = original.toJson();
        final restored = OrderModel.fromJson(json);

        expect(restored.notes, isNull);
      });
    });

    group('Edge cases', () {
      test('should handle very large quantity values', () {
        final order = OrderModel(
          id: 'EDGE001',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 999999999.99,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        expect(order.quantity, 999999999.99);
      });

      test('should handle zero quantity', () {
        final order = OrderModel(
          id: 'EDGE002',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 0.0,
          unit: 'units',
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
        );

        expect(order.quantity, 0.0);
      });

      test('should handle very long string values', () {
        final longString = 'A' * 1000;
        final order = OrderModel(
          id: 'EDGE003',
          customer: longString,
          crop: longString,
          variety: longString,
          quantity: 100.0,
          unit: longString,
          orderDate: testOrderDate,
          deliveryDate: testDeliveryDate,
          status: OrderStatus.pending,
          notes: longString,
        );

        expect(order.customer.length, 1000);
        expect(order.notes?.length, 1000);
      });

      test('should handle same orderDate and deliveryDate', () {
        final sameDate = DateTime(2024, 1, 15);
        final order = OrderModel(
          id: 'EDGE004',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: sameDate,
          deliveryDate: sameDate,
          status: OrderStatus.pending,
        );

        expect(order.orderDate, order.deliveryDate);
      });

      test('should handle deliveryDate before orderDate', () {
        final laterDate = DateTime(2024, 1, 20);
        final earlierDate = DateTime(2024, 1, 10);
        final order = OrderModel(
          id: 'EDGE005',
          customer: 'Customer',
          crop: 'Crop',
          variety: 'Variety',
          quantity: 100.0,
          unit: 'units',
          orderDate: laterDate,
          deliveryDate: earlierDate,
          status: OrderStatus.pending,
        );

        expect(order.deliveryDate.isBefore(order.orderDate), true);
      });
    });
  });
}