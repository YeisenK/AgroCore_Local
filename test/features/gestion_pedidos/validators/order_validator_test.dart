import 'package:flutter_test/flutter_test.dart';
import 'package:agrocore_app/features/gestion_pedidos/validators/order_validator.dart';

void main() {
  group('OrderValidator', () {
    group('validateCustomer', () {
      test('should return null for valid customer name', () {
        expect(OrderValidator.validateCustomer('John Doe'), isNull);
        expect(OrderValidator.validateCustomer('Customer Name'), isNull);
        expect(OrderValidator.validateCustomer('AB'), isNull);
      });

      test('should return error for null customer', () {
        final result = OrderValidator.validateCustomer(null);
        expect(result, isNotNull);
        expect(result, 'El cliente es requerido');
      });

      test('should return error for empty customer', () {
        final result = OrderValidator.validateCustomer('');
        expect(result, isNotNull);
        expect(result, 'El cliente es requerido');
      });

      test('should return error for customer with less than 2 characters', () {
        final result = OrderValidator.validateCustomer('A');
        expect(result, isNotNull);
        expect(result, 'El nombre debe tener al menos 2 caracteres');
      });

      test('should accept customer with exactly 2 characters', () {
        expect(OrderValidator.validateCustomer('AB'), isNull);
      });

      test('should accept customer with whitespace', () {
        expect(OrderValidator.validateCustomer('John Doe'), isNull);
        expect(OrderValidator.validateCustomer('  John  '), isNull);
      });

      test('should accept customer with special characters', () {
        expect(OrderValidator.validateCustomer('José María'), isNull);
        expect(OrderValidator.validateCustomer("O'Brien"), isNull);
        expect(OrderValidator.validateCustomer('Smith-Jones'), isNull);
      });

      test('should accept customer with numbers', () {
        expect(OrderValidator.validateCustomer('Customer 123'), isNull);
      });

      test('should accept very long customer names', () {
        final longName = 'A' * 1000;
        expect(OrderValidator.validateCustomer(longName), isNull);
      });
    });

    group('validateCrop', () {
      test('should return null for valid crop name', () {
        expect(OrderValidator.validateCrop('Tomato'), isNull);
        expect(OrderValidator.validateCrop('Corn'), isNull);
        expect(OrderValidator.validateCrop('A'), isNull);
      });

      test('should return error for null crop', () {
        final result = OrderValidator.validateCrop(null);
        expect(result, isNotNull);
        expect(result, 'El cultivo es requerido');
      });

      test('should return error for empty crop', () {
        final result = OrderValidator.validateCrop('');
        expect(result, isNotNull);
        expect(result, 'El cultivo es requerido');
      });

      test('should accept crop with single character', () {
        expect(OrderValidator.validateCrop('A'), isNull);
      });

      test('should accept crop with whitespace', () {
        expect(OrderValidator.validateCrop('Sweet Corn'), isNull);
        expect(OrderValidator.validateCrop('  Tomato  '), isNull);
      });

      test('should accept crop with special characters', () {
        expect(OrderValidator.validateCrop('Café'), isNull);
        expect(OrderValidator.validateCrop('Maíz'), isNull);
      });

      test('should accept crop with numbers', () {
        expect(OrderValidator.validateCrop('Type 123'), isNull);
      });

      test('should accept very long crop names', () {
        final longCrop = 'A' * 1000;
        expect(OrderValidator.validateCrop(longCrop), isNull);
      });
    });

    group('validateVariety', () {
      test('should return null for valid variety name', () {
        expect(OrderValidator.validateVariety('Cherry'), isNull);
        expect(OrderValidator.validateVariety('Hybrid'), isNull);
        expect(OrderValidator.validateVariety('A'), isNull);
      });

      test('should return error for null variety', () {
        final result = OrderValidator.validateVariety(null);
        expect(result, isNotNull);
        expect(result, 'La variedad es requerida');
      });

      test('should return error for empty variety', () {
        final result = OrderValidator.validateVariety('');
        expect(result, isNotNull);
        expect(result, 'La variedad es requerida');
      });

      test('should accept variety with single character', () {
        expect(OrderValidator.validateVariety('A'), isNull);
      });

      test('should accept variety with whitespace', () {
        expect(OrderValidator.validateVariety('Cherry Tomato'), isNull);
        expect(OrderValidator.validateVariety('  Hybrid  '), isNull);
      });

      test('should accept variety with special characters', () {
        expect(OrderValidator.validateVariety('Variedad-A'), isNull);
        expect(OrderValidator.validateVariety('Type #1'), isNull);
      });

      test('should accept variety with numbers', () {
        expect(OrderValidator.validateVariety('Variety 123'), isNull);
        expect(OrderValidator.validateVariety('123'), isNull);
      });

      test('should accept very long variety names', () {
        final longVariety = 'A' * 1000;
        expect(OrderValidator.validateVariety(longVariety), isNull);
      });
    });

    group('validateQuantity', () {
      test('should return null for valid positive integer quantities', () {
        expect(OrderValidator.validateQuantity('1'), isNull);
        expect(OrderValidator.validateQuantity('100'), isNull);
        expect(OrderValidator.validateQuantity('999999'), isNull);
      });

      test('should return null for valid positive decimal quantities', () {
        expect(OrderValidator.validateQuantity('1.5'), isNull);
        expect(OrderValidator.validateQuantity('100.99'), isNull);
        expect(OrderValidator.validateQuantity('0.1'), isNull);
        expect(OrderValidator.validateQuantity('0.01'), isNull);
      });

      test('should return error for null quantity', () {
        final result = OrderValidator.validateQuantity(null);
        expect(result, isNotNull);
        expect(result, 'La cantidad es requerida');
      });

      test('should return error for empty quantity', () {
        final result = OrderValidator.validateQuantity('');
        expect(result, isNotNull);
        expect(result, 'La cantidad es requerida');
      });

      test('should return error for zero quantity', () {
        final result = OrderValidator.validateQuantity('0');
        expect(result, isNotNull);
        expect(result, 'La cantidad debe ser mayor a 0');
      });

      test('should return error for negative quantities', () {
        expect(OrderValidator.validateQuantity('-1'), isNotNull);
        expect(OrderValidator.validateQuantity('-100'), isNotNull);
        expect(OrderValidator.validateQuantity('-0.5'), isNotNull);
      });

      test('should return error for non-numeric values', () {
        expect(OrderValidator.validateQuantity('abc'), isNotNull);
        expect(OrderValidator.validateQuantity('12abc'), isNotNull);
        expect(OrderValidator.validateQuantity('abc12'), isNotNull);
      });

      test('should return error for special characters', () {
        expect(OrderValidator.validateQuantity('!@#'), isNotNull);
        expect(OrderValidator.validateQuantity('$100'), isNotNull);
      });

      test('should handle whitespace in quantity', () {
        // Whitespace should fail parsing
        expect(OrderValidator.validateQuantity('  '), isNotNull);
        expect(OrderValidator.validateQuantity(' 100 '), isNull); // trim happens during parse
      });

      test('should handle very large quantities', () {
        expect(OrderValidator.validateQuantity('999999999'), isNull);
        expect(OrderValidator.validateQuantity('999999999.99'), isNull);
      });

      test('should handle very small positive quantities', () {
        expect(OrderValidator.validateQuantity('0.00001'), isNull);
      });

      test('should return error for zero with decimal', () {
        expect(OrderValidator.validateQuantity('0.0'), isNotNull);
        expect(OrderValidator.validateQuantity('0.00'), isNotNull);
      });

      test('should handle multiple decimal points', () {
        expect(OrderValidator.validateQuantity('1.2.3'), isNotNull);
      });

      test('should handle scientific notation', () {
        // Scientific notation should be parseable
        expect(OrderValidator.validateQuantity('1e2'), isNull); // 100
        expect(OrderValidator.validateQuantity('1.5e2'), isNull); // 150
      });
    });

    group('validateDeliveryDate', () {
      test('should return null for future dates', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(OrderValidator.validateDeliveryDate(tomorrow), isNull);

        final nextWeek = DateTime.now().add(const Duration(days: 7));
        expect(OrderValidator.validateDeliveryDate(nextWeek), isNull);

        final nextYear = DateTime.now().add(const Duration(days: 365));
        expect(OrderValidator.validateDeliveryDate(nextYear), isNull);
      });

      test('should return null for today', () {
        final today = DateTime.now();
        expect(OrderValidator.validateDeliveryDate(today), isNull);
      });

      test('should return error for null date', () {
        final result = OrderValidator.validateDeliveryDate(null);
        expect(result, isNotNull);
        expect(result, 'La fecha de entrega es requerida');
      });

      test('should return error for past dates', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final result = OrderValidator.validateDeliveryDate(yesterday);
        expect(result, isNotNull);
        expect(result, 'La fecha no puede ser anterior a hoy');
      });

      test('should return error for dates in the past week', () {
        final lastWeek = DateTime.now().subtract(const Duration(days: 7));
        final result = OrderValidator.validateDeliveryDate(lastWeek);
        expect(result, isNotNull);
      });

      test('should return error for dates in the past year', () {
        final lastYear = DateTime.now().subtract(const Duration(days: 365));
        final result = OrderValidator.validateDeliveryDate(lastYear);
        expect(result, isNotNull);
      });

      test('should handle date at midnight today', () {
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);
        expect(OrderValidator.validateDeliveryDate(todayMidnight), isNull);
      });

      test('should handle date with time component', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1, hours: 5));
        expect(OrderValidator.validateDeliveryDate(tomorrow), isNull);
      });

      test('should correctly compare dates ignoring time', () {
        final now = DateTime.now();
        // Same day but earlier time should be valid
        final todayEarlier = DateTime(now.year, now.month, now.day, 0, 0, 0);
        expect(OrderValidator.validateDeliveryDate(todayEarlier), isNull);
      });

      test('should handle edge case of yesterday at 23:59', () {
        final now = DateTime.now();
        final yesterdayLate = DateTime(
          now.year,
          now.month,
          now.day - 1,
          23,
          59,
          59,
        );
        final result = OrderValidator.validateDeliveryDate(yesterdayLate);
        expect(result, isNotNull);
      });

      test('should handle far future dates', () {
        final farFuture = DateTime.now().add(const Duration(days: 3650)); // 10 years
        expect(OrderValidator.validateDeliveryDate(farFuture), isNull);
      });

      test('should handle leap year dates', () {
        final leapDay = DateTime(2024, 2, 29);
        final now = DateTime.now();
        if (leapDay.isAfter(now) || leapDay.isAtSameMomentAs(now)) {
          expect(OrderValidator.validateDeliveryDate(leapDay), isNull);
        } else {
          expect(OrderValidator.validateDeliveryDate(leapDay), isNotNull);
        }
      });
    });

    group('Integration tests', () {
      test('should validate complete order data - valid case', () {
        expect(OrderValidator.validateCustomer('John Doe'), isNull);
        expect(OrderValidator.validateCrop('Tomato'), isNull);
        expect(OrderValidator.validateVariety('Cherry'), isNull);
        expect(OrderValidator.validateQuantity('100'), isNull);
        expect(
          OrderValidator.validateDeliveryDate(
            DateTime.now().add(const Duration(days: 7)),
          ),
          isNull,
        );
      });

      test('should validate complete order data - all invalid', () {
        expect(OrderValidator.validateCustomer(''), isNotNull);
        expect(OrderValidator.validateCrop(''), isNotNull);
        expect(OrderValidator.validateVariety(''), isNotNull);
        expect(OrderValidator.validateQuantity('0'), isNotNull);
        expect(
          OrderValidator.validateDeliveryDate(
            DateTime.now().subtract(const Duration(days: 1)),
          ),
          isNotNull,
        );
      });

      test('should validate minimum valid data', () {
        expect(OrderValidator.validateCustomer('AB'), isNull);
        expect(OrderValidator.validateCrop('A'), isNull);
        expect(OrderValidator.validateVariety('A'), isNull);
        expect(OrderValidator.validateQuantity('0.01'), isNull);
        expect(OrderValidator.validateDeliveryDate(DateTime.now()), isNull);
      });
    });
  });
}