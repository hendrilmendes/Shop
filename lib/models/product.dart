class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> colors;
  final List<String> sizes;
  final double shippingCost;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.colors,
    required this.sizes,
    required this.shippingCost,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      colors: List<String>.from(json['colors']),
      sizes: List<String>.from(json['sizes']),
      shippingCost: json['shippingCost'].toDouble(),
      category: json['category'],
    );
  }
}
