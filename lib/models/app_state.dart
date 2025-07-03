import 'package:flutter/material.dart';
import 'dart:typed_data';

class Product {
  final String name;
  final IconData icon;
  final int price;
  final String category;
  final String? imageUrl;
  final String? description;
  final List<String> specifications;

  Product({
    required this.name,
    required this.icon,
    required this.price,
    required this.category,
    this.imageUrl,
    this.description,
    this.specifications = const [],
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => (product.price * quantity).toDouble();
}

// Order and Payment models
class Order {
  final String orderId;
  final List<Product> products;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final String paymentMethod;
  final String? deliveryAddress;

  Order({
    required this.orderId,
    required this.products,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.paymentMethod,
    this.deliveryAddress,
  });
}

class PaymentTransaction {
  final String transactionId;
  final String orderId;
  final double amount;
  final DateTime date;
  final String status;
  final String paymentMethod;
  final List<String> products;

  PaymentTransaction({
    required this.transactionId,
    required this.orderId,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.products,
  });
}

class AdBanner {
  final String imageUrl;
  AdBanner({required this.imageUrl});
}

class AppState extends ChangeNotifier {
  final List<CartItem> _cart = [];
  final List<Product> _wishlist = [];

  // Order and Payment tracking
  final List<Order> _orders = [];
  final List<PaymentTransaction> _transactions = [];

  // Ad Banners
  final List<AdBanner> _adBanners = [];

  // Sample orders for testing (admin functionality)
  List<Order> get sampleOrders => [
    Order(
      orderId: 'ORD001',
      products: [_products[0]], // iPhone 15 Pro
      totalAmount: 129999.0,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Pending',
      paymentMethod: 'Credit Card',
      deliveryAddress: '123 Main St, City, State',
    ),
    Order(
      orderId: 'ORD002',
      products: [_products[1], _products[2]], // Sony Headphones + MacBook Air
      totalAmount: 107998.0,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Processing',
      paymentMethod: 'UPI',
      deliveryAddress: '456 Oak Ave, City, State',
    ),
    Order(
      orderId: 'ORD003',
      products: [_products[3]], // Smart Speaker
      totalAmount: 4999.0,
      orderDate: DateTime.now().subtract(const Duration(hours: 12)),
      status: 'Shipped',
      paymentMethod: 'Debit Card',
      deliveryAddress: '789 Pine Rd, City, State',
    ),
    Order(
      orderId: 'ORD004',
      products: [_products[4]], // Nike Shoes
      totalAmount: 2999.0,
      orderDate: DateTime.now().subtract(const Duration(hours: 6)),
      status: 'Delivered',
      paymentMethod: 'Cash on Delivery',
      deliveryAddress: '321 Elm St, City, State',
    ),
    Order(
      orderId: 'ORD005',
      products: [_products[0], _products[1]], // iPhone + Headphones
      totalAmount: 137998.0,
      orderDate: DateTime.now().subtract(const Duration(hours: 3)),
      status: 'Cancelled',
      paymentMethod: 'Net Banking',
      deliveryAddress: '654 Maple Dr, City, State',
    ),
  ];

  // Combined orders for admin view
  List<Order> get allOrders => [..._orders, ...sampleOrders];

  // Products (shared for admin and user)
  final List<Product> _products = [
    Product(
      name: 'iPhone 15 Pro',
      icon: Icons.phone_iphone,
      price: 129999,
      category: 'Mobiles',
      description:
          'Latest iPhone with advanced features and powerful performance.',
      specifications: [
        'A17 Pro chip',
        '48MP camera system',
        '6.1-inch display',
        'Titanium design',
        'Face ID',
      ],
    ),
    Product(
      name: 'Sony Headphones',
      icon: Icons.headphones,
      price: 7999,
      category: 'Electronics',
      description: 'Premium wireless headphones with noise cancellation.',
      specifications: [
        'Active Noise Cancellation',
        '30-hour battery life',
        'Bluetooth 5.0',
        'Touch controls',
        'Quick charge',
      ],
    ),
    Product(
      name: 'MacBook Air',
      icon: Icons.laptop_mac,
      price: 99999,
      category: 'Electronics',
      description: 'Ultra-thin laptop with M2 chip for powerful performance.',
      specifications: [
        'M2 chip',
        '13.6-inch display',
        '18-hour battery',
        '8GB RAM',
        'macOS Ventura',
      ],
    ),
    Product(
      name: 'Smart Speaker',
      icon: Icons.speaker,
      price: 4999,
      category: 'Home',
      description: 'Voice-controlled smart speaker for your home.',
      specifications: [
        'Voice assistant',
        '360-degree sound',
        'Smart home control',
        'WiFi connectivity',
        'Multi-room audio',
      ],
    ),
    Product(
      name: 'Nike Shoes',
      icon: Icons.directions_run,
      price: 2999,
      category: 'Fashion',
      description: 'Comfortable running shoes with advanced cushioning.',
      specifications: [
        'Air Max technology',
        'Breathable mesh',
        'Rubber outsole',
        'Lightweight design',
        'Multiple colors',
      ],
    ),
  ];

  // Settings
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  // Navigation state
  int _selectedTabIndex = 0;

  // Categories (shared for admin)
  final List<String> _categories = [
    'Mobiles',
    'Electronics',
    'Home',
    'Fashion',
    'Sports',
    'More',
  ];

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Product> get wishlist => List.unmodifiable(_wishlist);
  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);
  List<Order> get orders => List.unmodifiable(_orders);
  List<PaymentTransaction> get transactions => List.unmodifiable(_transactions);
  List<AdBanner> get adBanners => List.unmodifiable(_adBanners);

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  int get selectedTabIndex => _selectedTabIndex;

  // Cart total calculations
  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

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

  void switchToTab(int index) {
    if (_selectedTabIndex != index) {
      _selectedTabIndex = index;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    // Check if product already exists in cart
    final existingItemIndex = _cart.indexWhere(
      (item) => item.product == product,
    );

    if (existingItemIndex >= 0) {
      // Increase quantity if product already exists
      _cart[existingItemIndex].quantity++;
    } else {
      // Add new item to cart
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  void updateCartItemQuantity(Product product, int quantity) {
    final itemIndex = _cart.indexWhere((item) => item.product == product);
    if (itemIndex >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(itemIndex);
      } else {
        _cart[itemIndex].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
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

  // Check if product is in cart
  bool isInCart(Product product) {
    return _cart.any((item) => item.product == product);
  }

  // Check if product is in wishlist
  bool isInWishlist(Product product) {
    return _wishlist.contains(product);
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

  // Order management methods for admin
  void updateOrderStatus(String orderId, String newStatus) {
    // Update in real orders
    final orderIndex = _orders.indexWhere((order) => order.orderId == orderId);
    if (orderIndex >= 0) {
      final oldOrder = _orders[orderIndex];
      _orders[orderIndex] = Order(
        orderId: oldOrder.orderId,
        products: oldOrder.products,
        totalAmount: oldOrder.totalAmount,
        orderDate: oldOrder.orderDate,
        status: newStatus,
        paymentMethod: oldOrder.paymentMethod,
        deliveryAddress: oldOrder.deliveryAddress,
      );
      notifyListeners();
    }
  }

  // Filter orders by status
  List<Order> getOrdersByStatus(String status) {
    if (status == 'All') {
      return allOrders;
    }
    return allOrders.where((order) => order.status == status).toList();
  }

  // Get order statistics for admin analytics
  Map<String, int> getOrderStatusStats() {
    final stats = <String, int>{};
    for (final status in [
      'Pending',
      'Processing',
      'Shipped',
      'Delivered',
      'Cancelled',
      'Refunded',
    ]) {
      stats[status] = allOrders.where((order) => order.status == status).length;
    }
    return stats;
  }

  // Get revenue analytics
  double getTotalRevenue() {
    return allOrders
        .where(
          (order) => order.status != 'Cancelled' && order.status != 'Refunded',
        )
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  double getMonthlyRevenue() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return allOrders
        .where(
          (order) =>
              order.orderDate.isAfter(startOfMonth) &&
              order.status != 'Cancelled' &&
              order.status != 'Refunded',
        )
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Get top selling products
  List<Map<String, dynamic>> getTopProducts() {
    final productCounts = <String, int>{};
    for (final order in allOrders) {
      if (order.status != 'Cancelled' && order.status != 'Refunded') {
        for (final product in order.products) {
          productCounts[product.name] = (productCounts[product.name] ?? 0) + 1;
        }
      }
    }

    final sortedProducts = productCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedProducts
        .take(5)
        .map((entry) => {'name': entry.key, 'count': entry.value})
        .toList();
  }

  // Buy Now functionality - creates immediate order
  Future<bool> buyNow(
    Product product,
    String paymentMethod, {
    String? address,
  }) async {
    try {
      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      // Create order
      final order = Order(
        orderId: orderId,
        products: [product],
        totalAmount: product.price.toDouble(),
        orderDate: DateTime.now(),
        status: 'Processing',
        paymentMethod: paymentMethod,
        deliveryAddress: address,
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Create payment transaction
      final transaction = PaymentTransaction(
        transactionId: transactionId,
        orderId: orderId,
        amount: product.price.toDouble(),
        date: DateTime.now(),
        status: 'Completed',
        paymentMethod: paymentMethod,
        products: [product.name],
      );

      // Add to orders and transactions
      _orders.add(order);
      _transactions.add(transaction);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Process cart checkout
  Future<bool> checkoutCart(String paymentMethod, {String? address}) async {
    if (_cart.isEmpty) return false;

    try {
      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      final products = _cart.map((item) => item.product).toList();
      final total = cartTotal;

      // Create order
      final order = Order(
        orderId: orderId,
        products: products,
        totalAmount: total,
        orderDate: DateTime.now(),
        status: 'Processing',
        paymentMethod: paymentMethod,
        deliveryAddress: address,
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      // Create payment transaction
      final transaction = PaymentTransaction(
        transactionId: transactionId,
        orderId: orderId,
        amount: total,
        date: DateTime.now(),
        status: 'Completed',
        paymentMethod: paymentMethod,
        products: products.map((p) => p.name).toList(),
      );

      // Add to orders and transactions
      _orders.add(order);
      _transactions.add(transaction);

      // Clear cart after successful payment
      clearCart();

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Ad Banner CRUD
  void addAdBanner(AdBanner banner) {
    _adBanners.add(banner);
    notifyListeners();
  }

  void updateAdBanner(int index, AdBanner updatedBanner) {
    if (index >= 0 && index < _adBanners.length) {
      _adBanners[index] = updatedBanner;
      notifyListeners();
    }
  }

  void deleteAdBanner(int index) {
    if (index >= 0 && index < _adBanners.length) {
      _adBanners.removeAt(index);
      notifyListeners();
    }
  }

  void setAdBanners(List<AdBanner> banners) {
    _adBanners
      ..clear()
      ..addAll(banners);
    notifyListeners();
  }

  Uint8List? _adImage;
  Uint8List? get adImage => _adImage;
  void setAdImage(Uint8List? image) {
    _adImage = image;
    notifyListeners();
  }
}
