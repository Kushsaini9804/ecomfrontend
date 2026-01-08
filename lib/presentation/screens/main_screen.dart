// lib/presentation/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile/presentation/screens/product_search_delegate.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

import 'product_list_screen.dart';
import 'cart_screen.dart';
import 'my_orders_screen.dart';
import 'account_screen.dart';

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
    // Fetch cart on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId ?? '';
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.userId ?? '';

    // Build pages here to safely access context
    final List<Widget> _pages = [
      const ProductListScreen(),        // Home
      CartScreen(userId: userId),       // Cart with userId
      const MyOrdersScreen(),           // My Orders
      const AccountScreen(),            // Account
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shop Live",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [

              // 🔍 SEARCH ICON (LEFT)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),


          // // LOGOUT
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () async {
          //     await context.read<AuthProvider>().logout();
          //     if (mounted) {
          //       Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          //     }
          //   },
          // ),

          //log out

          IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              await context.read<AuthProvider>().logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (_) => false,
                );
              }
            }
          },
        ),


          // LIGHT / DARK MODE TOGGLE
          IconButton(
            icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggle(),
          ),
        ],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          // Cart with badge
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (_, cart, __) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cart.items.isNotEmpty)
                      Positioned(
                        right: -6,
                        top: -3,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.red,
                          child: Text(
                            cart.items.length.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: "Cart",
          ),

          const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "My Orders"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
