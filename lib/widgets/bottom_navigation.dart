import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavigationContainer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationContainer({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_bag),
          label: AppLocalizations.of(context)!.purchased,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: AppLocalizations.of(context)!.shopCart,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: AppLocalizations.of(context)!.favorites,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings,
        ),
      ],
    );
  }
}
