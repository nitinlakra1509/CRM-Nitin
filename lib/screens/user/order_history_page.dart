import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': '1001', 'date': '2025-06-01', 'amount': '₹1200'},
      {'id': '1002', 'date': '2025-06-15', 'amount': '₹800'},
      {'id': '1003', 'date': '2025-07-01', 'amount': '₹500'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final order = orders[i];
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text('Order #${order['id']}'),
            subtitle: Text('Date: ${order['date']}'),
            trailing: Text(order['amount']!),
          );
        },
      ),
    );
  }
}
