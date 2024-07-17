class Order {
  final String id;
  final String customerName;
  final String date;
  final double amount;
  final List<String> products;

  Order({
    required this.id,
    required this.customerName,
    required this.date,
    required this.amount,
    required this.products,
  });
}
