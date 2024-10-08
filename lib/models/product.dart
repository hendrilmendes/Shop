class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> imageUrls;
  final List<String> colors;
  final List<String> sizes;
  final double shippingCost;
  final String category;
  final bool isOutOfStock;
  final double discount;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.colors,
    required this.sizes,
    required this.shippingCost,
    required this.category,
    required this.isOutOfStock,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      colors:
          (json['colors'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sizes: (json['sizes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? '',
      isOutOfStock: json['isOutOfStock'] == true,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'colors': colors,
      'sizes': sizes,
      'shippingCost': shippingCost,
      'category': category,
      'isOutOfStock': isOutOfStock,
      'discount': discount,
    };
  }
}
