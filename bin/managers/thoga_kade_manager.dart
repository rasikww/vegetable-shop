import '../models/vegetable.dart';
import '../repositories/inventory_repository.dart';
import '../models/order.dart';

abstract class ThogaKadeState {}

class LoadingState extends ThogaKadeState {}

class LoadedState extends ThogaKadeState {
  final List<Vegetable> inventory;

  LoadedState(this.inventory);
}

class ErrorState extends ThogaKadeState {
  final String message;

  ErrorState(this.message);
}

class ThogaKadeManager {
  final _inventoryRepository = InventoryRepository();
  ThogaKadeState _state = LoadingState();

  ThogaKadeState get state => _state;

  Future<void> loadInventory() async {
    _state = LoadingState();
    try {
      await _inventoryRepository.loadInventory();
      _state = LoadedState(_inventoryRepository.listVegetables());
    } on Exception catch (e) {
      _state = ErrorState('Failed to load inventory: $e');
    }
  }

  void addVegetable(Vegetable vegetable) {
    try {
      _inventoryRepository.addVegetable(vegetable);
      _state = LoadedState(_inventoryRepository.listVegetables());
    } on Exception catch (e) {
      _state = ErrorState('Failed to add vegetable: $e');
    }
  }

  void updateStock(int id, double quantity) {
    try {
      _inventoryRepository.updateStock(id, quantity);
      _state = LoadedState(_inventoryRepository.listVegetables());
    } on Exception catch (e) {
      _state = ErrorState('Failed to update stock: $e');
    }
  }

  void removeVegetable(int id) {
    try {
      _inventoryRepository.removeVegetable(id);
      _state = LoadedState(_inventoryRepository.listVegetables());
    } on Exception catch (e) {
      _state = ErrorState('Failed to remove vegetable: $e');
    }
  }

  void processOrder(Order order) {
    try {
      _inventoryRepository.saveInventory();
      _state = LoadedState(_inventoryRepository.listVegetables());
    } on Exception catch (e) {
      _state = ErrorState('Failed to process order: $e');
    }
  }

  void generateReport() {
    try {
      _state = LoadedState(_inventoryRepository.listVegetables());
    } on Exception catch (e) {
      _state = ErrorState('Failed to generate report: $e');
    }
  }
}
