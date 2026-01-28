import 'package:flutter/material.dart';
import 'package:mobile/presentation/screens/product_search_delegate.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

import 'product_list_screen.dart';
import 'cart_screen.dart';
import 'category_screen.dart';
import 'my_orders_screen.dart';
import 'account_screen.dart';

import '../widgets/glass_bottom_navbar.dart'; // 👈 IMPORTANT

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.userId ?? '';

    /// ✅ SCREENS (ORDER MUST MATCH NAV INDEX)
    final pages = [
      const ProductListScreen(), // 0 Home
      CartScreen(userId: userId), // 1 Cart
      const CategoryScreen(),    // 2 Categories
      const MyOrdersScreen(),    // 3 Orders
      const AccountScreen(),     // 4 Account
    ];

    return Scaffold(
      extendBody: true, // 🔥 REQUIRED FOR GLASS EFFECT

      appBar: AppBar(
        title: const Text(
          "Shop Live",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [

          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),


          /// THEME TOGGLE
          IconButton(
            icon: Icon(
              themeProvider.isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: themeProvider.toggle,
          ),
        ],
      ),

      /// ✅ BODY SWITCHES PROPERLY
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      /// ✅ LIQUID GLASS NAVBAR
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
