class Order {
  final String id;
  Map<String, double> items;
  double totalAmount;
  DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items,
      'totalAmount': totalAmount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: json['items'],
      totalAmount: json['totalAmount'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
