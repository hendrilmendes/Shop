import 'package:flutter/material.dart';
import 'package:shop/screens/product_details/product_details.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  const ProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: id,
        );
      },
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              // Adicionar ao carrinho
            },
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            '\$$price',
            textAlign: TextAlign.center,
          ),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
