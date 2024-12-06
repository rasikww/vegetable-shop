import 'dart:io';
import '../managers/thoga_kade_manager.dart';
import '../models/vegetable.dart';

void main() async {
  final ThogaKadeManager manager = ThogaKadeManager();

  print('Welcome to Thoga Kade Vegetable Shop CLI!');
  print('Loading inventory...');
  await manager.load();

  while (true) {
    print("====Thoga Kade Vegetable Shop CLI====");
    print('\nMenu:');
    print('0. Exit');
    print('1. Add Vegetable');
    print('2. View Inventory');
    print('3. Update Stock');
    print('4. Remove Vegetable');
    print('5. Place Order');
    print('6. Generate Report');

    stdout.write('Choose an option: ');

    final choice = stdin.readLineSync();

    if (choice == '0') {
      print('Goodbye!');
      print('Exiting Application...');
      break;
    }
    if (choice == '1') {
      stdout.write('Enter name: ');
      final name = stdin.readLineSync()!;
      stdout.write('Enter price per kg: ');
      final price = double.parse(stdin.readLineSync()!);
      stdout.write('Enter quantity: ');
      final quantity = double.parse(stdin.readLineSync()!);
      stdout.write('Enter category: ');
      final category = stdin.readLineSync()!;
      stdout.write('Enter expiry date (YYYY-MM-DD): ');
      final expiry = DateTime.parse(stdin.readLineSync()!);

      final vegetable = Vegetable(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        pricePerKg: price,
        availableQuantity: quantity,
        category: category,
        expiryDate: expiry,
      );

      manager.addVegetable(vegetable);
      print('Vegetable added!');
    } else if (choice == '2') {
      print('Current Inventory:');
      if (manager.state is LoadedState) {
        final inventory = (manager.state as LoadedState).inventory;
        for (var veg in inventory) {
          print(
              '${veg.name} - ${veg.pricePerKg}/kg - ${veg.availableQuantity}kg available');
        }
      }
    } else if (choice == '3') {
      print('Update Stock:');
      stdout.write('Enter vegetable ID: ');
      final id = stdin.readLineSync()!;
      stdout.write('Enter available quantity: ');
      final quantity = double.parse(stdin.readLineSync()!);
      manager.updateStock(id, quantity);
      print('Stock updated!');
    } else if (choice == '4') {
      print('Remove vegetable:');
      stdout.write('Enter vegetable ID: ');
      final id = stdin.readLineSync()!;
      manager.removeVegetable(id);
      print('Vegetable removed!');
    } else if (choice == '5') {
      Map<String, double> items = {};
      while (true) {
        print('Order items: ');
        stdout.write('Enter vegetable name: ');
        final vegName = stdin.readLineSync()!;
        if (!manager.vegetableExist(vegName)) {
          throw Exception('Vegetable not found');
        }
        stdout.write('Enter quantity: ');
        final vegQuantity = double.parse(stdin.readLineSync()!);
        if (!manager.isWantedAmountAvailable(vegName, vegQuantity)) {
          throw Exception('Insufficient stock for $vegName');
        }
        items[vegName] = vegQuantity;
        print('Do you want to add more items? (y/n)');
        final choice = stdin.readLineSync();
        if (choice?.toLowerCase() == 'y') {
          continue;
        } else {
          break;
        }
      }
      manager.placeOrder(items);
      print('Order placed!');
    } else if (choice == '6') {
      print('Generate Report:');
      manager.generateReport();
    } else {
      print('Invalid choice, try again.');
    }
  }
}
