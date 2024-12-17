import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop/provider/order_provider.dart';
import 'package:shop/screens/orders_details/orders_details.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myOrders,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.errorOrders),
            );
          } else {
            return Consumer<OrderProvider>(
              builder: (ctx, orderProvider, child) {
                final orders = orderProvider.orders;
                final currencyFormat = NumberFormat.currency(
                  locale: 'pt_BR',
                  symbol: 'R\$',
                );

                // Ordena os pedidos em ordem decrescente por data
                orders.sort((a, b) => b.date.compareTo(a.date));

                return orders.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noOrders,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (ctx, index) {
                          final order = orders[index];
                          return Card(
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.shopping_cart),
                                  ),
                                  title: Text(
                                    'Pedido #${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${order.customerName} - ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Chip(
                                        label: Text(
                                          currencyFormat.format(order.amount),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            OrderDetailScreen(order: order),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
              },
            );
          }
        },
      ),
    );
  }
}
