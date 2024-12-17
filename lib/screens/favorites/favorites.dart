import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/favorite_provider.dart';
import 'package:shop/screens/product_details/product_details.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favorite,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favoritesProvider.favorites.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noFav,
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: favoritesProvider.favorites.length,
              itemBuilder: (ctx, index) {
                final favoriteItem = favoritesProvider.favorites[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          favoriteItem.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      favoriteItem.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      numberFormat.format(favoriteItem.price),
                      style: const TextStyle(color: Colors.green),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.red,
                      onPressed: () async {
                        final appLocalizations = AppLocalizations.of(context);
                        if (appLocalizations != null) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(appLocalizations.favoriteDialog),
                              content: Text(
                                  'Tem certeza que deseja remover "${favoriteItem.title}" dos favoritos?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(appLocalizations.no),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(appLocalizations.yes),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            favoritesProvider.removeFavorite(favoriteItem.id);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    // ignore: use_build_context_synchronously
                                    Text(AppLocalizations.of(context)!
                                        .removedFav),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: favoriteItem
                            .id, // Passe o ID ou o item inteiro como argumento
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
