import 'package:feedback/feedback.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/category_provider.dart';
import 'package:shop/provider/favorite_provider.dart';
import 'package:shop/provider/order_provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/screens/cart/cart.dart';
import 'package:shop/screens/checkout/checout.dart';
import 'package:shop/screens/favorites/favorites.dart';
import 'package:shop/screens/orders/orders.dart';
import 'package:shop/screens/product_details/product_details.dart';
import 'package:shop/screens/rotes/rotes.dart';
import 'package:shop/screens/settings/settings.dart';
import 'package:shop/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<Map<String, dynamic>>('favoritesbox');

  runApp(
    BetterFeedback(
      theme: FeedbackThemeData.light(),
      darkTheme: FeedbackThemeData.dark(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalFeedbackLocalizationsDelegate(),
      ],
      localeOverride: const Locale('pt'),
      child: const MyApp(),
    ),
  );
}

ThemeMode _getThemeMode(ThemeModeType mode) {
  switch (mode) {
    case ThemeModeType.light:
      return ThemeMode.light;
    case ThemeModeType.dark:
      return ThemeMode.dark;
    case ThemeModeType.system:
      return ThemeMode.system;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = 'user123';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(userId),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesProvider()..init(),
        ),
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => ThemeModel(),
        ),
      ],
      child: Consumer<ThemeModel>(builder: (_, themeModel, __) {
        return MaterialApp(
          theme: ThemeModel.lightTheme(),
          darkTheme: ThemeModel.darkTheme(),
          themeMode: _getThemeMode(themeModel.themeMode),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: '/',
          routes: {
            '/': (ctx) => const MainScreen(),
            '/order': (ctx) => const OrdersScreen(),
            '/cart': (ctx) => const CartScreen(),
            FavoritesScreen.routeName: (ctx) => const FavoritesScreen(),
            '/settings': (ctx) => const SettingsScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
          },
        );
      }),
    );
  }
}
