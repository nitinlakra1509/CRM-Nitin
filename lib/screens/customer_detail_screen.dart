import 'package:flutter/material.dart';
import 'package:nitin/models/customer.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({required this.customer, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(customer.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${customer.name}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Email: ${customer.email}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Phone: ${customer.phone}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
