import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final wishlist = appState.wishlist;
    return Scaffold(
      body: wishlist.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, i) {
                final p = wishlist[i];
                return ListTile(
                  leading: Icon(p.icon, color: Colors.pinkAccent),
                  title: Text(p.name),
                  subtitle: Text('₹${p.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => appState.removeFromWishlist(p),
                  ),
                );
              },
            ),
    );
  }
}
