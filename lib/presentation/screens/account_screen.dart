import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'US';

    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

@override
Widget build(BuildContext context) {
  final auth = context.watch<AuthProvider>();
  final name = auth.userName ?? 'User';
  final initials = getInitials(name);

  return SafeArea(
    bottom: true, // ✅ THIS FIXES NAVBAR OVERLAP
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          /// 👤 PROFILE
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.indigo,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text("My Cart"),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/my-orders');
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text("My Orders"),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
            icon: const Icon(Icons.favorite),
            label: const Text("My Wishlist"),
          ),

          const SizedBox(height: 16),



          /// ✏️ EDIT PROFILE
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile"),
          ),

          const SizedBox(height: 16),

          /// 📍 SAVED ADDRESS
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/saved-address');
            },
            icon: const Icon(Icons.location_on),
            label: const Text("Saved Address"),
          ),

          const Spacer(),

          /// 🚪 LOGOUT (NOW VISIBLE)
          ElevatedButton.icon(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {//add context
                await context.read<AuthProvider>().logout(context);
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                }
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    ),
  );
}
}
