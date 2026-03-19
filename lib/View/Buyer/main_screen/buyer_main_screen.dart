import 'package:ecommerce_shopping_store/ViewModel/Bloc/buyer_main_screen_bloc/buyer_main_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:ecommerce_shopping_store/View/views.dart';


class BuyerMainScreen extends StatefulWidget {
  const BuyerMainScreen({super.key});

  @override
  State<BuyerMainScreen> createState() => _BuyerMainScreenState();
}

class _BuyerMainScreenState extends State<BuyerMainScreen> {

  late BuyerMainNavBloc _mainNavBloc;

  final List<Widget> _pages = const [
    BuyerHomeScreen(),
    BuyerCartScreen(),
    BuyerOrdersScreen(),
    BuyerProfileScreen(),
  ];

  final List<NavItem> navItems = const [
    NavItem(icon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.shopping_cart_rounded, label: 'Cart'),
    NavItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
    NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainNavBloc = BuyerMainNavBloc();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _mainNavBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => _mainNavBloc,
      child: BlocBuilder<BuyerMainNavBloc, BuyerMainNavState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: IndexedStack(
              index: state.selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: _GlassNavBar(
              currentIndex: state.selectedIndex,
              items: navItems,
              onTap: (i) => context.read<BuyerMainNavBloc>().add(BuyerMainNavTabChanged(i)),
            ),
          );
        },
      ),
    );
  }
}

// ── Glass Nav Bar ────────────────────────────────────────────────────────────
class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  const _GlassNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              bottom: bottomPadding > 0 ? bottomPadding : 10,
              left: 8,
              right: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final selected = index == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.85)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[index].icon,
                          color: selected ? Colors.white : Colors.grey.shade600,
                          size: 22,
                        ),
                        if (selected) ...[
                          const SizedBox(width: 6),
                          Text(
                            items[index].label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem({required this.icon, required this.label});
}