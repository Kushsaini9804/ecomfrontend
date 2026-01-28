import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              /// 🔹 DARK BASE (VERY IMPORTANT)
              Container(
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.15),
                    ],
                  ),
                ),
              ),

              /// 🔹 BLUR LAYER
              Blur(
                blur: 18,
                colorOpacity: 0.12,
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                ),
              ),

              /// 🔹 ICONS
              SizedBox(
                height: 72,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home,
                      index: 0,
                      currentIndex: currentIndex,
                      onTap: onTap,
                    ),
                    _CartNavItem(
                      index: 1,
                      currentIndex: currentIndex,
                      onTap: onTap,
                    ),
                    _NavItem(
                      icon: Icons.category,
                      index: 2,
                      currentIndex: currentIndex,
                      onTap: onTap,
                    ),
                    _NavItem(
                      icon: Icons.receipt_long,
                      index: 3,
                      currentIndex: currentIndex,
                      onTap: onTap,
                    ),
                    _NavItem(
                      icon: Icons.person,
                      index: 4,
                      currentIndex: currentIndex,
                      onTap: onTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected
              ? const Color.fromARGB(255, 66, 83, 210).withOpacity(0.25)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: selected ? 30 : 26,
          color: selected
              ? Colors.white
              : Colors.white.withOpacity(0.7), // 👈 FIX
        ),
      ),
    );
  }
}

class _CartNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _CartNavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Consumer<CartProvider>(
        builder: (_, cart, __) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? const Color.fromARGB(255, 66, 83, 210).withOpacity(0.25)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.shopping_cart,
                  size: selected ? 30 : 26,
                  color: selected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                ),
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: -6,
                  top: -6,
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
    );
  }
}
