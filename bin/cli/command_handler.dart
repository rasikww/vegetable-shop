import 'dart:io';
import '../managers/thoga_kade_manager.dart';
import '../models/vegetable.dart';

void main() async {
  final ThogaKadeManager manager = ThogaKadeManager();

  print('Welcome to Thoga Kade Vegetable Shop CLI!');
  print('Loading inventory...');
  await manager.loadInventory();

  while (true) {
    print('\nMenu:');
    print('1. Add Vegetable');
    print('2. List Inventory');
    print('3. Exit');
    stdout.write('Choose an option: ');

    final choice = stdin.readLineSync();

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
      print('Goodbye!');
      break;
    } else {
      print('Invalid choice, try again.');
    }
  }
}
