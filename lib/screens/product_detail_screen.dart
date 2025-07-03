import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'buy_now_page.dart';

const primaryBlue = Color(0xFF232F3E);
const accentYellow = Color.fromARGB(255, 80, 114, 138);

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final inCart = appState.isInCart(product);
    final inWishlist = appState.isInWishlist(product);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              inWishlist ? Icons.favorite : Icons.favorite_border,
              color: inWishlist ? Colors.red : Colors.white,
            ),
            onPressed: () {
              if (inWishlist) {
                appState.removeFromWishlist(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} removed from wishlist'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                appState.addToWishlist(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to wishlist'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[50],
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Icon(product.icon, size: 100, color: primaryBlue),
                ),
              ),
            ),

            // Product Info Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentYellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      const Text(
                        'Price: ',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description Section
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getProductDescription(product),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Features Section
                  const Text(
                    'Key Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._getProductFeatures(product).map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Rating Section
                  Row(
                    children: [
                      const Text(
                        'Rating: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '4.0 (128 reviews)',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Buy Now Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentYellow,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuyNowPage(product: product),
                    ),
                  );
                },
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: inCart ? Colors.grey : primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                onPressed: inCart
                    ? null
                    : () {
                        appState.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'View Cart',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                ); // Go back to main screen
                                // You might want to navigate to cart tab here
                              },
                            ),
                          ),
                        );
                      },
                child: Text(
                  inCart ? 'In Cart' : 'Add to Cart',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductDescription(Product product) {
    final descriptions = {
      'iPhone 15 Pro':
          'The iPhone 15 Pro features a titanium design, A17 Pro chip, and Action Button. Experience next-level photography with the new 48MP camera system and up to 4x optical zoom.',
      'Sony Headphones':
          'Premium wireless headphones with industry-leading noise cancellation. Enjoy up to 30 hours of battery life and crystal-clear sound quality.',
      'MacBook Air':
          'The new MacBook Air with M2 chip delivers incredible performance in an ultra-thin design. Perfect for work, creativity, and entertainment.',
      'Smart Speaker':
          'Voice-controlled smart speaker with premium sound quality. Control your smart home, play music, and get answers to your questions.',
      'Nike Shoes':
          'Comfortable and stylish athletic shoes designed for performance. Features advanced cushioning technology and breathable materials.',
    };

    return descriptions[product.name] ??
        'High-quality ${product.category.toLowerCase()} product designed to meet your needs. Experience premium features and exceptional performance.';
  }

  List<String> _getProductFeatures(Product product) {
    final features = {
      'iPhone 15 Pro': [
        'A17 Pro chip with 6-core GPU',
        'ProRAW and ProRes video recording',
        'Titanium design with Action Button',
        'Up to 29 hours video playback',
        'Face ID for secure authentication',
      ],
      'Sony Headphones': [
        'Industry-leading noise cancellation',
        '30-hour battery life',
        'Quick Charge: 10 minutes for 5 hours',
        'Touch sensor controls',
        'Premium comfortable design',
      ],
      'MacBook Air': [
        'M2 chip with 8-core CPU',
        '13.6-inch Liquid Retina display',
        'Up to 18 hours battery life',
        'MagSafe charging',
        'Ultra-thin and lightweight design',
      ],
      'Smart Speaker': [
        'Voice control with AI assistant',
        '360-degree premium sound',
        'Smart home hub capabilities',
        'Multi-room audio support',
        'Privacy controls built-in',
      ],
      'Nike Shoes': [
        'Advanced cushioning technology',
        'Breathable mesh upper',
        'Durable rubber outsole',
        'Lightweight design',
        'Available in multiple colors',
      ],
    };

    return features[product.name] ??
        [
          'Premium quality materials',
          'Modern design',
          'User-friendly interface',
          'Reliable performance',
          'Great value for money',
        ];
  }
}
