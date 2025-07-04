import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/app_state.dart';
import 'product_detail_screen.dart';

const primaryBlue = Color(0xFF232F3E);
const accentYellow = Color.fromARGB(255, 80, 114, 138);

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
    'Completed',
    'Pending',
    'Failed',
    'Refunded',
  ];

  // --- Helpers at the top ---
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'processing':
        return Icons.sync;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'refunded':
        return Icons.replay;
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: label == 'Status'
                    ? _getStatusColor(value)
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
      case 'debit card':
        return Icons.credit_card;
      case 'upi':
        return Icons.account_balance_wallet;
      case 'net banking':
        return Icons.account_balance;
      case 'cash on delivery':
        return Icons.local_shipping;
      default:
        return Icons.payment;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: primaryBlue,
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search orders or transactions...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),

                // Tab bar
                TabBar(
                  controller: _tabController,
                  indicatorColor: accentYellow,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Orders'),
                    Tab(text: 'Transactions'),
                  ],
                ),
              ],
            ),
          ),

          // Filter chips row
          _buildFilterChips(),

          // Tab view content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Orders tab
                _buildOrdersList(context),

                // Transactions tab
                _buildTransactionsList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: accentYellow,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = appState.orders; // Use user's real orders

    // Filter orders based on selected filter and search query
    final filteredOrders = orders.where((order) {
      final matchesFilter =
          _selectedFilter == 'All' || order.status == _selectedFilter;
      final matchesSearch =
          _searchQuery.isEmpty ||
          order.orderId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.products.any(
            (product) =>
                product.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      return matchesFilter && matchesSearch;
    }).toList();

    if (filteredOrders.isEmpty) {
      return _buildEmptyOrdersState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(context, order, appState);
      },
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final allTransactions = _getFilteredTransactions(appState);

    if (allTransactions.isEmpty) {
      return _buildEmptyTransactionsState();
    }

    return SizedBox(
      width: double.infinity,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allTransactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final transaction = allTransactions[index];
          return _buildTransactionCard(transaction);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order, AppState appState) {
    final formattedDate = DateFormat('MMM d, yyyy').format(order.orderDate);
    final statusColor = _getStatusColor(order.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showOrderDetails(context, order, appState),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Order ID and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              const Divider(),

              // Products preview
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    final product = order.products[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(product.icon, color: primaryBlue, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Status and Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order.status),
                          size: 14,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${order.totalAmount.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTransactions(AppState appState) {
    final allTransactions = _getAppTransactions(appState);

    // Filter transactions based on search query and selected filter
    return allTransactions.where((transaction) {
      final matchesFilter =
          _selectedFilter == 'All' ||
          transaction['status'].toLowerCase() == _selectedFilter.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          transaction['orderId'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          ((transaction['products'] as List<String>).any(
            (product) =>
                product.toLowerCase().contains(_searchQuery.toLowerCase()),
          ));

      return matchesFilter && matchesSearch;
    }).toList();
  }

  Widget _buildEmptyOrdersState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactionsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your payment history will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showTransactionDetails(transaction),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        transaction['status'],
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(transaction['status']),
                      color: _getStatusColor(transaction['status']),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${transaction['orderId']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction['date'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${transaction['amount']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryBlue,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(transaction['status']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          transaction['status'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Payment Method and Items
              Row(
                children: [
                  Icon(
                    _getPaymentMethodIcon(transaction['paymentMethod']),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    transaction['paymentMethod'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    '${transaction['items']} items',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAppTransactions(AppState appState) {
    final transactions = appState.transactions;

    // Convert PaymentTransaction objects to Map for display
    return transactions.map((transaction) {
      return {
        'orderId': transaction.orderId,
        'date': DateFormat('yyyy-MM-dd').format(transaction.date),
        'amount': transaction.amount.toInt(),
        'status': transaction.status,
        'paymentMethod': transaction.paymentMethod,
        'items': transaction.products.length,
        'products': transaction.products,
        'transactionId': transaction
            .transactionId, // Include the transaction ID for reference
      };
    }).toList();
  }

  void _showOrderDetails(BuildContext context, Order order, AppState appState) {
    final formattedDate = DateFormat('MMM d, yyyy').format(order.orderDate);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStatusIcon(order.status),
                          color: _getStatusColor(order.status),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.orderId}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Placed on $formattedDate',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  _buildDetailRow('Status', order.status),
                  _buildDetailRow('Payment Method', order.paymentMethod),
                  if (order.deliveryAddress != null)
                    _buildDetailRow('Delivery Address', order.deliveryAddress!),
                  _buildDetailRow(
                    'Total Amount',
                    '₹${order.totalAmount.toInt()}',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Items in this order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: order.products.length,
                      separatorBuilder: (_, __) => const Divider(height: 20),
                      itemBuilder: (context, index) {
                        final product = order.products[index];
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(product.icon, color: primaryBlue),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('₹${product.price}'),
                          trailing: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryBlue),
                            ),
                            child: const Text('View'),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order #${transaction['orderId']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Date', transaction['date']),
              _buildDetailRow('Amount', '₹${transaction['amount']}'),
              _buildDetailRow('Status', transaction['status']),
              _buildDetailRow('Payment Method', transaction['paymentMethod']),
              _buildDetailRow('Items', '${transaction['items']}'),
              const SizedBox(height: 8),
              const Text(
                'Products:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...((transaction['products'] is List<String>)
                  ? (transaction['products'] as List<String>).map(
                      (product) => Text('• $product'),
                    )
                  : (transaction['products'] as List).map(
                      (product) =>
                          Text('•  0{product.name ?? product.toString()}'),
                    )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (transaction['status'] == 'Completed')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Download receipt feature coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Download Receipt'),
              ),
          ],
        );
      },
    );
  }
}
