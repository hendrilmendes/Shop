import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/favorite_provider.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final Product loadedProduct =
        Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(productId);

    // Criar um formatador de número com vírgula como separador decimal
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    final formattedPrice = formatter.format(loadedProduct.price);

    // Calcular o preço com desconto, se houver
    final double discountedPrice;
    discountedPrice =
        loadedProduct.price * (1 - (loadedProduct.discount / 100));
    final formattedDiscountedPrice = formatter.format(discountedPrice);

    // Verifica se o frete é gratuito ou não e formata o valor do frete
    final shippingCostText = loadedProduct.shippingCost == 0
        ? 'Grátis'
        : 'R\$ ${formatter.format(loadedProduct.shippingCost)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFavorite(loadedProduct.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto removido dos favoritos!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                favoritesProvider.addFavorite(loadedProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto adicionado aos favoritos!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Carrossel de Imagens
            CarouselSlider(
              items: loadedProduct.imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Mostrar preço original riscado, se houver desconto
                  if (loadedProduct.discount > 0)
                    Text(
                      'R\$ $formattedPrice',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(width: 10),
                  // Mostrar preço com desconto, se houver
                  Text(
                    'R\$ $formattedDiscountedPrice',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(Icons.color_lens),
                  const SizedBox(width: 10),
                  Text(
                    'Cores disponíveis: ${loadedProduct.colors.join(', ')}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(Icons.straighten),
                  const SizedBox(width: 10),
                  Text(
                    'Tamanhos disponíveis: ${loadedProduct.sizes.join(', ')}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping),
                  const SizedBox(width: 10),
                  Text(
                    'Valor do frete: $shippingCostText',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                'Código do Produto: $productId',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Provider.of<CartProvider>(context, listen: false).addItem(
            loadedProduct.id,
            loadedProduct.title,
            loadedProduct.price,
            loadedProduct.imageUrls.isNotEmpty
                ? loadedProduct.imageUrls[0]
                : '',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto adicionado ao carrinho!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
