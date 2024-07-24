import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/favorite_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favoritesProvider.favorites.isEmpty
          ? const Center(
              child: Text('Nenhum item favorito.'),
            )
          : ListView.builder(
              itemCount: favoritesProvider.favorites.length,
              itemBuilder: (ctx, index) {
                final favoriteItem = favoritesProvider.favorites[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    leading: Image.network(favoriteItem.imageUrl),
                    title: Text(favoriteItem.title),
                    subtitle:
                        Text('R\$ ${favoriteItem.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        favoritesProvider.removeFavorite(favoriteItem.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
