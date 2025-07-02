import 'package:flutter/material.dart';
import 'package:nitin/models/customer.dart';
import 'add_customer_screen.dart';
import 'customer_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Customer> customers;
  final void Function(Customer) onAddCustomer;

  const HomeScreen({
    required this.customers,
    required this.onAddCustomer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer List')),
      body: customers.isEmpty
          ? const Center(child: Text('No customers yet.'))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(customers[i].name),
                subtitle: Text(customers[i].email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CustomerDetailScreen(customer: customers[i]),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCustomer = await Navigator.push<Customer>(
            context,
            MaterialPageRoute(builder: (_) => AddCustomerScreen()),
          );
          if (newCustomer != null) {
            onAddCustomer(newCustomer);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
