import 'package:flutter/material.dart';

class Product {
  final String name;
  final IconData icon;
  final int price;
  final String category;

  Product({
    required this.name,
    required this.icon,
    required this.price,
    required this.category,
  });
}

class AppState extends ChangeNotifier {
  final List<Product> _cart = [];
  final List<Product> _wishlist = [];

  // Products (shared for admin and user)
  final List<Product> _products = [
    Product(
      name: 'iPhone 15 Pro',
      icon: Icons.phone_iphone,
      price: 129999,
      category: 'Mobiles',
    ),
    Product(
      name: 'Sony Headphones',
      icon: Icons.headphones,
      price: 7999,
      category: 'Electronics',
    ),
    Product(
      name: 'MacBook Air',
      icon: Icons.laptop_mac,
      price: 99999,
      category: 'Electronics',
    ),
    Product(
      name: 'Smart Speaker',
      icon: Icons.speaker,
      price: 4999,
      category: 'Home',
    ),
    Product(
      name: 'Nike Shoes',
      icon: Icons.directions_run,
      price: 2999,
      category: 'Fashion',
    ),
  ];

  // Settings
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  // Categories (shared for admin)
  final List<String> _categories = [
    'Mobiles',
    'Electronics',
    'Home',
    'Fashion',
    'Sports',
    'More',
  ];

  List<Product> get cart => List.unmodifiable(_cart);
  List<Product> get wishlist => List.unmodifiable(_wishlist);
  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  set isDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }

  set notificationsEnabled(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    if (!_cart.contains(product)) {
      _cart.add(product);
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void addToWishlist(Product product) {
    if (!_wishlist.contains(product)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    _wishlist.remove(product);
    notifyListeners();
  }

  // Product filtering
  List<Product> productsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    return _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Advanced sync: notify listeners on all product/category changes
  void addCategory(String name) {
    if (!_categories.contains(name)) {
      _categories.add(name);
      notifyListeners();
    }
  }

  void removeCategory(String name) {
    _categories.remove(name);
    // Remove products in this category
    _products.removeWhere((p) => p.category == name);
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  bool isInCart(Product product) => _cart.contains(product);
  bool isInWishlist(Product product) => _wishlist.contains(product);
}
