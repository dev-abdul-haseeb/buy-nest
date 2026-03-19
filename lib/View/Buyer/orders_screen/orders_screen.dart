import 'package:flutter/material.dart';

class BuyerOrdersScreen extends StatelessWidget {
  const BuyerOrdersScreen({super.key});

  final List<Map<String, dynamic>> _orders = const [
    {
      'id': '#ORD-1042',
      'date': 'Mar 15, 2025',
      'status': 'Delivered',
      'total': '\$49.99',
      'items': 3,
    },
    {
      'id': '#ORD-1038',
      'date': 'Mar 10, 2025',
      'status': 'In Transit',
      'total': '\$89.00',
      'items': 2,
    },
    {
      'id': '#ORD-1031',
      'date': 'Mar 02, 2025',
      'status': 'Processing',
      'total': '\$29.99',
      'items': 1,
    },
    {
      'id': '#ORD-1020',
      'date': 'Feb 22, 2025',
      'status': 'Cancelled',
      'total': '\$120.00',
      'items': 5,
    },
  ];

  Color _statusColor(String status) => switch (status) {
    'Delivered' => Colors.green,
    'In Transit' => Colors.blue,
    'Processing' => Colors.orange,
    'Cancelled' => Colors.red,
    _ => Colors.grey,
  };

  IconData _statusIcon(String status) => switch (status) {
    'Delivered' => Icons.check_circle_rounded,
    'In Transit' => Icons.local_shipping_rounded,
    'Processing' => Icons.hourglass_top_rounded,
    'Cancelled' => Icons.cancel_rounded,
    _ => Icons.info_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = _orders[index];
          final color = _statusColor(order['status']);
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(order['id'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon(order['status']),
                                size: 13, color: color),
                            const SizedBox(width: 4),
                            Text(order['status'],
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                          icon: Icons.calendar_today_rounded,
                          text: order['date']),
                      const SizedBox(width: 16),
                      _InfoChip(
                          icon: Icons.shopping_bag_rounded,
                          text: '${order['items']} items'),
                      const Spacer(),
                      Text(order['total'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color:
                              Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}