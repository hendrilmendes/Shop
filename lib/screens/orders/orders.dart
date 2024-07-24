import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
              itemBuilder: (ctx, index) {
                final order = orders[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 5,
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.shopping_cart),
                          ),
                          title: Text('Pedido #${order.id}'),
                          subtitle: Text(
                            '${order.customerName} - ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}',
                          ),
                          trailing: Chip(
                            label:
                                Text('R\$ ${order.amount.toStringAsFixed(2)}'),
                          ),
                          onTap: () {
                            // Navegar para detalhes do pedido
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    OrderDetailScreen(order: order),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: order.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.title} (${item.quantity})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido #${order.id}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cliente: ${order.customerName}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: R\$ ${order.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Itens:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.title} (${item.quantity})',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'R\$ ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
