import '../services/file_service.dart';
import '../models/vegetable.dart';

class InventoryRepository {
  final FileService _fileService =
      FileService('bin/repositories/inventory.json');
  final List<Vegetable> _inventory = [];

  // Loads the inventory data from a file and fill the `_inventory` list.
  Future<void> loadInventory() async {
    final data = await _fileService.readFile();
    if (data != null) {
      _inventory.clear();
      _inventory.addAll(data.map((item) => Vegetable.fromJson(item)).toList());
    }
  }

  // Saves the current inventory to a file.
  void saveInventory() {
    final data = _inventory.map((item) => item.toJson()).toList();
    _fileService.writeFile(data);
  }

  void addVegetable(Vegetable vegetable) {
    _inventory.add(vegetable);
  }

  // Lists all vegetables in the inventory.
  // If [lowStock] is true, only returns vegetables with a quantity of
  // less than 10.
  List<Vegetable> listVegetables({bool lowStock = false}) {
    if (lowStock) {
      return _inventory.where((item) => item.availableQuantity < 10).toList();
    }
    return _inventory;
  }

  void updateStock(String id, double quantity) {
    final vegetable = _inventory.firstWhere((item) => item.id == id);
    vegetable.availableQuantity = quantity;
  }

  void removeVegetable(String id) {
    _inventory.removeWhere((item) => item.id == id);
  }

  Vegetable getVegetableById(String id) {
    return _inventory.firstWhere((item) => item.id == id);
  }

  Vegetable getVegetableByName(String name) {
    return _inventory.firstWhere((item) => item.name == name);
  }

  bool vegetableExists(String name) {
    return _inventory.any((item) => item.name == name);
  }
}
