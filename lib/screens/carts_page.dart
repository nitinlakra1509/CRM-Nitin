import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class CartsPage extends StatelessWidget {
  const CartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final cart = appState.cart;
    return Scaffold(
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, i) {
                final p = cart[i];
                return ListTile(
                  leading: Icon(p.icon, color: Colors.blueGrey),
                  title: Text(p.name),
                  subtitle: Text('₹${p.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => appState.removeFromCart(p),
                  ),
                );
              },
            ),
    );
  }
}
