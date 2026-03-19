import 'package:ecommerce_shopping_store/ViewModel/Bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.person_outline_rounded, 'title': 'Edit Profile'},
    {'icon': Icons.location_on_outlined, 'title': 'Saved Addresses'},
    {'icon': Icons.payment_rounded, 'title': 'Payment Methods'},
    {'icon': Icons.notifications_none_rounded, 'title': 'Notifications'},
    {'icon': Icons.help_outline_rounded, 'title': 'Help & Support'},
    {'icon': Icons.privacy_tip_outlined, 'title': 'Privacy Policy'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + name
            const CircleAvatar(
              radius: 48,
              backgroundImage:
              NetworkImage('https://picsum.photos/seed/avatar/200/200'),
            ),
            const SizedBox(height: 12),
            const Text('John Doe',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('johndoe@email.com',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),

            // Stats row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _StatItem(value: '12', label: 'Orders'),
                  _StatItem(value: '3', label: 'Wishlist'),
                  _StatItem(value: '5', label: 'Reviews'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu list
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 56),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'],
                          size: 20,
                          color:
                          Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(item['title']),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.grey),
                    onTap: () {},
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.read<AuthBloc>().add(AuthLogOut()),
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: const Text('Logout',
                    style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 80), // space for nav bar
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}