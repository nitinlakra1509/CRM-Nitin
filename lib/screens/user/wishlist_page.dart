import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final wishlist = appState.wishlist;
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlist.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: wishlist.length,
              separatorBuilder: (_, __) => const Divider(),
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
