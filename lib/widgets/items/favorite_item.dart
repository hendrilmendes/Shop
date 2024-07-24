class FavoriteItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  // Converte o objeto em um mapa para armazenar no Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Cria o objeto a partir de um mapa
  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}
