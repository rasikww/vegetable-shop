import '../services/file_service.dart';
import '../models/order.dart';

class OrderRepository {
  final FileService _orderFileService =
      FileService('../repositories/orders.json');
  final List<Order> _orders = [];

  Future<void> loadOrders() async {
    final data = await _orderFileService.readFile();
    if (data != null) {
      _orders.clear();
      _orders.addAll(data.map((item) => Order.fromJson(item)).toList());
    }
  }

  void saveOrders() {
    final data = _orders.map((item) => item.toJson()).toList();
    _orderFileService.writeFile(data);
  }

  void addOrder(Order order) {
    _orders.add(order);
  }

  List<Order> listOrders() {
    return _orders;
  }
}
