import '../services/file_service.dart';
import '../models/vegetable.dart';

class InventoryRepository {
  final FileService _fileService = FileService('inventory.json');
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
  Future<void> saveInventory() async {
    final data = _inventory.map((item) => item.toJson()).toList();
    await _fileService.writeFile(data);
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

  void updateStock(int id, double quantity) {
    final vegetable = _inventory.firstWhere((item) => item.id == id);
    vegetable.availableQuantity += quantity;
  }

  void removeVegetable(int id) {
    _inventory.removeWhere((item) => item.id == id);
  }
}
