import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/favorite_provider.dart';
import 'package:intl/intl.dart';
import 'package:shop/screens/image/image.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedColor;
  String? selectedSize;
  final int _currentIndex = 0;
  late Product loadedProduct;

  void _onImageTapped(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => FullScreenImage(
          imageUrls: loadedProduct.imageUrls,
          initialIndex: _currentIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    loadedProduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(productId);

    // Criar um formatador de número com vírgula como separador decimal
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    final formattedPrice = formatter.format(loadedProduct.price);
    final double discountedPrice =
        loadedProduct.price * (1 - (loadedProduct.discount / 100));
    final formattedDiscountedPrice = formatter.format(discountedPrice);
    final double shippingCost = loadedProduct.shippingCost;
    final shippingCostText =
        shippingCost == 0 ? 'Grátis' : 'R\$ ${formatter.format(shippingCost)}';

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
                  SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.removeFavProduct),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                favoritesProvider.addFavorite(loadedProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.addFavProduct),
                    duration: const Duration(seconds: 2),
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
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 250,
                  maxWidth: MediaQuery.sizeOf(context).width - 10,
                ),
                child: CarouselView(
                  itemExtent: 320,
                  onTap: _onImageTapped,
                  itemSnapping: true,
                  children: loadedProduct.imageUrls.map((imageUrl) {
                    return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                loadedProduct.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (loadedProduct.discount > 0)
                    Text(
                      'R\$ $formattedPrice',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Text(
                    'R\$ $formattedDiscountedPrice',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                loadedProduct.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.color_lens),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: loadedProduct.colors.map((color) {
                        return ChoiceChip(
                          label: Text(color),
                          selected: selectedColor == color,
                          onSelected: (selected) {
                            setState(() {
                              selectedColor = selected ? color : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.straighten),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: loadedProduct.sizes.map((size) {
                        return ChoiceChip(
                          label: Text(size),
                          selected: selectedSize == size,
                          onSelected: (selected) {
                            setState(() {
                              selectedSize = selected ? size : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Código do Produto: $productId',
                style: const TextStyle(
                  fontSize: 14,
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
          if (loadedProduct.isOutOfStock) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.outOfStockSub),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (selectedColor == null || selectedSize == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.addCartSub),
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            final double finalPrice = discountedPrice + shippingCost;

            Provider.of<CartProvider>(context, listen: false).addItem(
              loadedProduct.id,
              loadedProduct.title,
              finalPrice,
              loadedProduct.imageUrls.isNotEmpty
                  ? loadedProduct.imageUrls[0]
                  : '',
              selectedColor!,
              selectedSize!,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.addCart),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
