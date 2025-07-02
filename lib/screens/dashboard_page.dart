import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final products = appState.products;
    // Map categories to icons for display
    final Map<String, IconData> categoryIcons = {
      'Mobiles': Icons.phone_iphone,
      'Electronics': Icons.laptop,
      'Home': Icons.chair,
      'Fashion': Icons.watch,
      'Sports': Icons.sports_soccer,
      'More': Icons.more_horiz,
    };
    final categories = appState.categories;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF232F3E),
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Color(0xFF232F3E)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hello, Nitin!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Welcome to App',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF232F3E),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF232F3E), width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search products, services...',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF232F3E),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFF232F3E)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryPage(category: categories[i]),
                    ),
                  );
                },
                child: SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          categoryIcons[categories[i]] ?? Icons.category,
                          color: const Color(0xFF232F3E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categories[i],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF232F3E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Top Deals for You',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF232F3E),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              final inCart = appState.isInCart(p);
              final inWishlist = appState.isInWishlist(p);
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF232F3E), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Icon(
                            p.icon,
                            size: 36,
                            color: const Color(0xFF232F3E),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF232F3E),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '₹${p.price}',
                        style: const TextStyle(
                          color: Color(0xFF232F3E),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            inWishlist ? Icons.favorite : Icons.favorite_border,
                            color: inWishlist ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            if (inWishlist) {
                              appState.removeFromWishlist(p);
                            } else {
                              appState.addToWishlist(p);
                            }
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: inCart
                                    ? Colors.grey
                                    : const Color(0xFF232F3E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: inCart
                                  ? null
                                  : () {
                                      appState.addToCart(p);
                                    },
                              child: Text(inCart ? 'In Cart' : 'Add to Cart'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final products = appState.productsByCategory(category);
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color(0xFF232F3E),
        foregroundColor: Colors.white,
      ),
      body: products.isEmpty
          ? Center(child: Text('No products for $category'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return ListTile(
                  leading: Icon(p.icon, color: const Color(0xFF232F3E)),
                  title: Text(p.name),
                  subtitle: Text('₹${p.price}'),
                );
              },
            ),
    );
  }
}
