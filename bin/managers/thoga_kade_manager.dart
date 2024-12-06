import '../models/vegetable.dart';
import '../repositories/inventory_repository.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

abstract class ThogaKadeState {}

class LoadingState extends ThogaKadeState {}

class LoadedState extends ThogaKadeState {
  final List<Vegetable> inventory;
  final List<Order> orders;

  LoadedState(this.inventory, this.orders);
}

class ErrorState extends ThogaKadeState {
  final String message;

  ErrorState(this.message);
}

class ThogaKadeManager {
  final _inventoryRepository = InventoryRepository();
  final _orderRepository = OrderRepository();

  ThogaKadeState _state = LoadingState();

  ThogaKadeState get state => _state;

  Future<void> load() async {
    _state = LoadingState();
    try {
      await _inventoryRepository.loadInventory();
      await _orderRepository.loadOrders();
      _state = LoadedState(
          _inventoryRepository.listVegetables(), _orderRepository.listOrders());
    } on Exception catch (e) {
      _state = ErrorState('Failed to load data: $e');
    }
  }

  void addVegetable(Vegetable vegetable) async {
    try {
      _inventoryRepository.addVegetable(vegetable);
      _inventoryRepository.saveInventory();
      _state = LoadedState(
          _inventoryRepository.listVegetables(), _orderRepository.listOrders());
    } on Exception catch (e) {
      _state = ErrorState('Failed to add vegetable: $e');
    }
  }

  void updateStock(String id, double quantity) {
    try {
      _inventoryRepository.updateStock(id, quantity);
      _inventoryRepository.saveInventory();
      _state = LoadedState(
          _inventoryRepository.listVegetables(), _orderRepository.listOrders());
    } on Exception catch (e) {
      _state = ErrorState('Failed to update stock: $e');
    }
  }

  void removeVegetable(String id) {
    try {
      _inventoryRepository.removeVegetable(id);
      _inventoryRepository.saveInventory();
      _state = LoadedState(
          _inventoryRepository.listVegetables(), _orderRepository.listOrders());
    } on Exception catch (e) {
      _state = ErrorState('Failed to remove vegetable: $e');
    }
  }

  void placeOrder(Map<String, double> items) {
    try {
      Order newOrder = processOrder(items);
      _orderRepository.addOrder(newOrder);
      _orderRepository.saveOrders();
      _inventoryRepository.saveInventory();
      _state = LoadedState(
          _inventoryRepository.listVegetables(), _orderRepository.listOrders());
    } on Exception catch (e) {
      _state = ErrorState('Failed to process order: $e');
    }
  }

  void generateReport() {
    try {
      _state = LoadedState(
          _inventoryRepository.listVegetables(), _orderRepository.listOrders());
    } on Exception catch (e) {
      _state = ErrorState('Failed to generate report: $e');
    }
  }

  bool vegetableExist(String name) {
    return _inventoryRepository.vegetableExists(name);
  }

  bool isWantedAmountAvailable(String name, double quantity) {
    final vegetable = _inventoryRepository.getVegetableByName(name);
    return vegetable.availableQuantity >= quantity;
  }

  Order processOrder(Map<String, double> items) {
    double totalAmount = 0.0;
    Vegetable vegetable;

    for (var entry in items.entries) {
      try {
        //entry:= vegetableName: quantity
        vegetable = _inventoryRepository.getVegetableByName(entry.key);
      } on StateError {
        throw Exception('Vegetable with name ${entry.key} not found.');
      }
      if (vegetable.availableQuantity < entry.value) {
        throw Exception('Insufficient stock for ${vegetable.name}.');
      }
      if (vegetable.expiryDate.isBefore(DateTime.now())) {
        throw Exception('${vegetable.name} is expired.');
      }

      // Calculate price
      totalAmount += vegetable.pricePerKg * entry.value;

      // Deduct stock
      _inventoryRepository.updateStock(
          vegetable.id, vegetable.availableQuantity - entry.value);

      try {
        _state = LoadedState(_inventoryRepository.listVegetables(),
            _orderRepository.listOrders());
      } on Exception catch (e) {
        _state = ErrorState('Failed to process order: $e');
      }
    }

    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      totalAmount: totalAmount,
      timestamp: DateTime.now(),
    );
  }
}
