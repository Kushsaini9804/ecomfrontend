import 'package:flutter/material.dart';
import 'package:mobile/data/models/product.dart';
import 'package:mobile/presentation/providers/product_provider.dart';
import 'package:mobile/presentation/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/order_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/product_list_screen.dart';
import 'presentation/screens/cart_screen.dart';
import 'presentation/screens/order_success_screen.dart';
import 'presentation/screens/checkout_screen.dart';
import 'presentation/screens/my_orders_screen.dart';
import 'presentation/screens/address_screen.dart';
import 'presentation/screens/edit_profile_screen.dart';
import 'presentation/screens/saved_address_screen.dart';
import 'presentation/screens/product_details_screen.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Live',
      theme: theme.isDark ? _darkTheme : _lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const _RootScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),

        //FIXED — userId coming from Provider
        '/home': (_) {
          final auth = context.read<AuthProvider>();
          return const MainScreen();
        },

        '/cart': (_) {
          final auth = context.read<AuthProvider>();
          return CartScreen(userId: auth.userId!);
        },
        '/edit-profile': (_) => const EditProfileScreen(),
        '/saved-address': (_) => const SavedAddressScreen(),

        '/checkout': (_) => const CheckoutScreen(),
        // '/address': (_) => const AddressScreen(),
        '/address': (context) {
          final product =
              ModalRoute.of(context)!.settings.arguments as Product?;
          return AddressScreen(product: product);
        },
        '/my-orders': (_) => const MyOrdersScreen(),
        '/order-success': (_) => const OrderSuccessScreen(),
        '/product-details': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Product;
        return ProductDetailsScreen(product: args);
      },

      },
    );
  }
}

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey[50],
  cardColor: Colors.white,
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
);

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey[900],
  cardColor: Colors.grey[850],
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
);

class _RootScreen extends StatelessWidget {
  const _RootScreen();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    Future.microtask(() {
      Navigator.pushReplacementNamed(
          context, (auth.isLoggedIn ?? false) ? '/home' : '/login');
    });

    return const SizedBox.shrink();
  }
}