import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Compras'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('Nenhuma compra realizada ainda.'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.shopping_cart),
                  ),
                  title: Text('Pedido #${orders[index].id}'),
                  subtitle: Text(
                      '${orders[index].customerName} - ${orders[index].date}'),
                  trailing: Chip(
                    label:
                        Text('R\$ ${orders[index].amount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
    );
  }
}
