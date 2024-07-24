import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _checkoutData = {
    'name': '',
    'address': '',
    'payment': '',
    'cardNumber': '',
    'pixKey': '',
  };

  String _paymentMethod = 'Dinheiro'; // Default payment method

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final formatter = NumberFormat('#,##0.00', 'pt_BR');

    final totalAmount = cart.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  onSaved: (value) {
                    _checkoutData['name'] = value ?? '';
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
                    _checkoutData['address'] = value ?? '';
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
                  value: _paymentMethod,
                  items: ['Dinheiro', 'Cartão', 'Pix', 'Boleto']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                  onSaved: (value) {
                    _checkoutData['payment'] = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um método de pagamento.';
                    }
                    return null;
                  },
                ),
                if (_paymentMethod == 'Cartão')
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Número do Cartão'),
                    onSaved: (value) {
                      _checkoutData['cardNumber'] = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número do cartão.';
                      }
                      return null;
                    },
                  ),
                if (_paymentMethod == 'Pix')
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Chave Pix'),
                    onSaved: (value) {
                      _checkoutData['pixKey'] = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a chave Pix.';
                      }
                      return null;
                    },
                  ),
                if (_paymentMethod == 'Boleto')
                  const Text(
                    'O boleto será gerado e enviado para o seu e-mail.',
                    style: TextStyle(color: Colors.grey),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'R\$ ${formatter.format(totalAmount)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Finalizar Pedido'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final cart = Provider.of<CartProvider>(context, listen: false);

      Provider.of<OrderProvider>(context, listen: false).addOrder(
        Order(
          id: DateTime.now().toString(),
          customerName: _checkoutData['name']!,
          address: _checkoutData['address']!,
          paymentMethod: _checkoutData['payment']!,
          amount: cart.totalAmount,
          date: DateTime.now(),
          items: cart.items,
        ),
      );

      cart.clear();
      Navigator.of(context).popUntil((route) => route.settings.name == '/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido realizado com sucesso!'),
        ),
      );
      Navigator.of(context).pushNamed('/order');
    }
  }
}
