import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../product_detail_screen.dart';
import '../dashboard_page.dart'; // Import DashboardPage

const primaryBlue = Color(0xFF232F3E);
const accentYellow = Color.fromARGB(255, 80, 114, 138);

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final wishlist = appState.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: wishlist.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'Add all to cart',
                  onPressed: () {
                    for (var product in wishlist) {
                      appState.addToCart(product);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All items added to cart'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Clear wishlist',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Wishlist?'),
                        content: const Text(
                          'Are you sure you want to remove all items from your wishlist?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              for (var product in List.from(wishlist)) {
                                appState.removeFromWishlist(product);
                              }
                            },
                            child: const Text('CLEAR'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: wishlist.isEmpty
          ? _buildEmptyWishlist(context)
          : _buildWishlistGrid(context, wishlist, appState),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your wishlist to save them for later',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              // Navigate to dashboard using Navigator instead of just popping
              final appState = Provider.of<AppState>(context, listen: false);
              appState.switchToTab(0); // Switch to home/dashboard (index 0)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(
    BuildContext context,
    List<Product> wishlist,
    AppState appState,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: wishlist.length,
      itemBuilder: (context, index) {
        final product = wishlist[index];
        return _buildProductCard(context, product, appState);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    AppState appState,
  ) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image or icon
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product image or icon background
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                            errorBuilder: (ctx, err, _) => Center(
                              child: Icon(
                                product.icon,
                                size: 60,
                                color: primaryBlue,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              product.icon,
                              size: 60,
                              color: primaryBlue,
                            ),
                          ),
                  ),
                  // Remove button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        color: Colors.red,
                        onPressed: () {
                          appState.removeFromWishlist(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} removed from wishlist',
                              ),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  appState.addToWishlist(product);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name and price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${product.price}',
                          style: TextStyle(
                            color: accentYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart, size: 16),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () {
                          appState.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
