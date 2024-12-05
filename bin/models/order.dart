class Order {
  final String id;
  Map<int, double> items;
  double totalAmount;
  DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items,
        'totalAmount': totalAmount,
        'timestamp': timestamp.toIso8601String(),
      };
}
