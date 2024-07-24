import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/screens/checkout/checout.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.shopCart),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Seu carrinho está vazio!'),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) => Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: cartItems[index].imageUrl !=
                                    'https://via.placeholder.com/150'
                                ? Image.network(
                                    cartItems[index].imageUrl,
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
                        title: Text(cartItems[index].title),
                        subtitle: Text('R\$ ${cartItems[index].price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('${cartItems[index].quantity}x'),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cart.removeItem(cartItems[index].productId);
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
                            'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
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
                          child: const Text('COMPRAR AGORA'),
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
            ),
    );
  }
}
