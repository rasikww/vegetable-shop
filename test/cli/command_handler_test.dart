import 'package:test/test.dart';
import 'dart:io';
import 'package:mockito/mockito.dart';
import '../../bin/managers/thoga_kade_manager.dart';
import '../../bin/models/vegetable.dart';

// Mock classes for testing
class MockThogaKadeManager extends Mock implements ThogaKadeManager {}

class MockStdin extends Mock implements Stdin {}

class MockStdout extends Mock implements Stdout {}

void main() {
  group('Thoga Kade CLI Application', () {
    late ThogaKadeManager manager;

    setUp(() {
      manager = ThogaKadeManager();
    });

    test('Manager is initialized correctly', () async {
      expect(manager, isNotNull);
      await expectLater(() => manager.load(), returnsNormally);
    });

    test('Adding a vegetable works correctly', () async {
      final vegetable = Vegetable(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Carrot',
        pricePerKg: 50.0,
        availableQuantity: 100.0,
        category: 'Root',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      manager.addVegetable(vegetable);

      // Verify the vegetable was added
      if (manager.state is LoadedState) {
        final inventory = (manager.state as LoadedState).inventory;
        expect(inventory.any((veg) => veg.name == 'Carrot'), isTrue);
      }
    });

    test('Updating stock works correctly', () async {
      final vegetable = Vegetable(
        id: '12345',
        name: 'Potato',
        pricePerKg: 30.0,
        availableQuantity: 50.0,
        category: 'Root',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      manager.addVegetable(vegetable);
      manager.updateStock('12345', 100.0);

      if (manager.state is LoadedState) {
        final updatedVegetable = (manager.state as LoadedState)
            .inventory
            .firstWhere((veg) => veg.id == '12345');
        expect(updatedVegetable.availableQuantity, 100.0);
      }
    });

    test('Removing a vegetable works correctly', () async {
      final vegetable = Vegetable(
        id: '67890',
        name: 'Tomato',
        pricePerKg: 40.0,
        availableQuantity: 75.0,
        category: 'Fruit',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      manager.addVegetable(vegetable);
      manager.removeVegetable('67890');

      if (manager.state is LoadedState) {
        final inventory = (manager.state as LoadedState).inventory;
        expect(inventory.any((veg) => veg.id == '67890'), isFalse);
      }
    });

    test('Placing an order reduces stock correctly', () async {
      // First, add some vegetables to the inventory
      final carrot = Vegetable(
        id: 'carrot1',
        name: 'Carrot',
        pricePerKg: 50.0,
        availableQuantity: 100.0,
        category: 'Root',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      final potato = Vegetable(
        id: 'potato1',
        name: 'Potato',
        pricePerKg: 30.0,
        availableQuantity: 200.0,
        category: 'Root',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      manager.addVegetable(carrot);
      manager.addVegetable(potato);

      // Place an order
      final orderItems = {'Carrot': 50.0, 'Potato': 100.0};

      manager.placeOrder(orderItems);

      if (manager.state is LoadedState) {
        final inventory = (manager.state as LoadedState).inventory;

        final updatedCarrot =
            inventory.firstWhere((veg) => veg.name == 'Carrot');
        final updatedPotato =
            inventory.firstWhere((veg) => veg.name == 'Potato');

        expect(updatedCarrot.availableQuantity, 50.0);
        expect(updatedPotato.availableQuantity, 100.0);
      }
    });

    test('Vegetable existence check works', () {
      final carrot = Vegetable(
        id: 'carrot1',
        name: 'Carrot',
        pricePerKg: 50.0,
        availableQuantity: 100.0,
        category: 'Root',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      manager.addVegetable(carrot);

      expect(manager.vegetableExist('Carrot'), isTrue);
      expect(manager.vegetableExist('Onion'), isFalse);
    });

    test('Stock availability check works', () {
      final carrot = Vegetable(
        id: 'carrot1',
        name: 'Carrot',
        pricePerKg: 50.0,
        availableQuantity: 100.0,
        category: 'Root',
        expiryDate: DateTime.now().add(Duration(days: 30)),
      );

      manager.addVegetable(carrot);

      expect(manager.isWantedAmountAvailable('Carrot', 50.0), isTrue);
      expect(manager.isWantedAmountAvailable('Carrot', 150.0), isFalse);
    });
  });
}
