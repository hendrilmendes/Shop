import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/order_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  Future<void> _showCheckoutDialog(BuildContext context, CartProvider cart) async {
    final formKey = GlobalKey<FormState>();
    final Map<String, String> checkoutData = {
      'name': '',
      'address': '',
      'payment': '',
    };

    String paymentMethod = 'Dinheiro'; // Método de pagamento padrão

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Finalizar Compra'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome Completo'),
                    onSaved: (value) {
                      checkoutData['name'] = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    onSaved: (value) {
                      checkoutData['address'] = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu endereço.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Método de Pagamento'),
                    value: paymentMethod,
                    items: ['Dinheiro', 'Cartão', 'Pix', 'Boleto']
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                    onSaved: (value) {
                      checkoutData['payment'] = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione um método de pagamento.';
                      }
                      return null;
                    },
                  ),
                  if (paymentMethod == 'Cartão')
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Número do Cartão'),
                      onSaved: (value) {
                        checkoutData['cardNumber'] = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o número do cartão.';
                        }
                        return null;
                      },
                    ),
                  if (paymentMethod == 'Pix')
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Chave Pix'),
                      onSaved: (value) {
                        checkoutData['pixKey'] = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a chave Pix.';
                        }
                        return null;
                      },
                    ),
                  if (paymentMethod == 'Boleto')
                    Text(
                      'O boleto será gerado e enviado para o seu e-mail.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child: const Text('FINALIZAR'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Provider.of<OrderProvider>(context, listen: false).addOrder(
                    Order(
                      id: DateTime.now().toString(),
                      customerName: checkoutData['name']!,
                      address: checkoutData['address']!,
                      paymentMethod: checkoutData['payment']!,
                      amount: cart.totalAmount,
                      date: DateTime.now(),
                      items: cart.items,
                    ),
                  );
                  cart.clear();
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pedido realizado com sucesso!'),
                    ),
                  );
                  Navigator.of(context).pushNamed('/order');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
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
                    itemBuilder: (ctx, index) => ListTile(
                      leading: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text('${cartItems[index].quantity}x'),
                          ),
                        ),
                      ),
                      title: Text(cartItems[index].title),
                      subtitle: Text('R\$ ${cartItems[index].price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cart.removeItem(cartItems[index].productId);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
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
                        const Spacer(),
                        Chip(
                          label: Text(
                            'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.headlineLarge!.color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        TextButton(
                          child: const Text('COMPRAR AGORA'),
                          onPressed: () {
                            _showCheckoutDialog(context, cart);
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
