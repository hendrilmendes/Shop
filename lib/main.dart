import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/auth/auth.dart';
import 'package:shop/firebase_options.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/category_provider.dart';
import 'package:shop/provider/favorite_provider.dart';
import 'package:shop/provider/order_provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/screens/cart/cart.dart';
import 'package:shop/screens/checkout/checout.dart';
import 'package:shop/screens/favorites/favorites.dart';
import 'package:shop/screens/login/login.dart';
import 'package:shop/screens/orders/orders.dart';
import 'package:shop/screens/product_details/product_details.dart';
import 'package:shop/screens/rotes/rotes.dart';
import 'package:shop/screens/settings/settings.dart';
import 'package:shop/theme/theme.dart';
import 'package:shop/updater/updater.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox<Map<String, dynamic>>('favoritesbox');

  // Strip Pagment
  Stripe.publishableKey =
      'pk_test_51PhgcYRrdJeN8anlmmWdatIlC2hvlaCCgNpSlq1Xi5D2mLxhmHRX5WEDdbogI466W5UIT3Y7j17EaIf2zgiGUmbh009EK7XbDu';

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

  // Firebase
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
    final AuthService authService = AuthService();

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
          create: (context) => OrderProvider(),
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
          home: _buildHome(authService),
          routes: {
            '/order': (ctx) => const OrdersScreen(),
            '/cart': (ctx) => const CartScreen(),
            FavoritesScreen.routeName: (ctx) => const FavoritesScreen(),
            '/settings': (ctx) => SettingsScreen(),
            '/login': (context) => LoginScreen(authService: authService),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
          },
        );
      }),
    );
  }
}

 Widget _buildHome(AuthService authService) {
    return FutureBuilder<User?>(
      future: authService.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Updater.checkUpdateApp(context);
          if (snapshot.hasData) {
             return const MainScreen();
          } else {
            return LoginScreen(authService: authService);
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
      },
    );
  }
