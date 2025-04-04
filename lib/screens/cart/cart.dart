import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/screens/checkout/checout.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.cart,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, cart, child) {
          if (cart.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noProductCart,
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          final currencyFormat =
              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, index) => Card(
                    clipBehavior: Clip.hardEdge,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: cart.items[index].imageUrl !=
                                  'https://via.placeholder.com/150'
                              ? Image.network(
                                  cart.items[index].imageUrl,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (ctx, error, stackTrace) {
                                    if (kDebugMode) {
                                      print('Error loading image: $error');
                                    }
                                    return const Icon(Icons.error,
                                        color: Colors.red);
                                  },
                                )
                              : Icon(Icons.image, color: Colors.grey[600]),
                        ),
                      ),
                      title: Text(cart.items[index].title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currencyFormat.format(cart.items[index].price),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Cor: ${cart.items[index].color}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Tamanho: ${cart.items[index].size}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('${cart.items[index].quantity}x'),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cart.removeItem(cart.items[index].productId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Chip(
                        label: Text(
                          currencyFormat.format(cart.totalAmount),
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium!
                                .color,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.buy),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CheckoutScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
