class CartItem {
  final String id; // ID único do item no carrinho
  final String productId; // ID do produto associado
  final String title; // Título do produto
  final int quantity; // Quantidade do produto no carrinho
  final double price; // Preço unitário do produto

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });
}
