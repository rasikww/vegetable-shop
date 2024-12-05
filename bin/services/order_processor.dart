import '../repositories/inventory_repository.dart';
import '../models/order.dart';
import '../models/vegetable.dart';
import '../repositories/order_repository.dart';

class OrderProcessingException implements Exception {
  final String message;
  OrderProcessingException(this.message);
}

class OrderProcessor {
  final InventoryRepository inventoryRepository;
  final OrderRepository orderRepository;

  OrderProcessor(this.inventoryRepository, this.orderRepository);

  Order processOrder(Map<String, double> items) {
    double totalAmount = 0.0;
    Vegetable vegetable;

    for (var entry in items.entries) {
      try {
        vegetable = inventoryRepository.getVegetableById(entry.key);
      } on StateError {
        throw OrderProcessingException('Vegetable ID ${entry.key} not found.');
      }
      if (vegetable.availableQuantity < entry.value) {
        throw OrderProcessingException(
            'Insufficient stock for ${vegetable.name}.');
      }
      if (vegetable.expiryDate.isBefore(DateTime.now())) {
        throw OrderProcessingException('${vegetable.name} is expired.');
      }

      // Calculate price
      totalAmount += vegetable.pricePerKg * entry.value;

      // Deduct stock
      inventoryRepository.updateStock(entry.key, -entry.value);
    }

    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      totalAmount: totalAmount,
      timestamp: DateTime.now(),
    );
  }
}
