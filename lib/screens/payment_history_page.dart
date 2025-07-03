import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

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
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Completed',
    'Pending',
    'Failed',
    'Refunded',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.payment, color: primaryBlue),
                    const SizedBox(width: 8),
                    const Text(
                      'Payment History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const Spacer(),
                    _buildFilterDropdown(),
                  ],
                ),
                const SizedBox(height: 16),
                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: primaryBlue,
                    tabs: const [
                      Tab(text: 'Transactions'),
                      Tab(text: 'Analytics'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTransactionsTab(), _buildAnalyticsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: _selectedFilter,
        icon: const Icon(Icons.filter_list, size: 18),
        underline: const SizedBox(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedFilter = newValue!;
          });
        },
        items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    final appState = Provider.of<AppState>(context);
    final transactions = _getFilteredTransactions(appState);

    if (transactions.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildEmptyState() {
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
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.switchToTab(0); // Switch to home/dashboard
            },
            child: const Text('Start Shopping'),
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
        child: Padding(
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

  Widget _buildAnalyticsTab() {
    final appState = Provider.of<AppState>(context);
    final analytics = _getAnalyticsData(appState);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Spent',
                  '₹${analytics['totalSpent']}',
                  Icons.account_balance_wallet,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Orders',
                  '${analytics['totalOrders']}',
                  Icons.shopping_bag,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Average Order',
                  '₹${analytics['averageOrder']}',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'This Month',
                  '₹${analytics['thisMonth']}',
                  Icons.calendar_month,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payment Methods Chart
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodsChart(analytics['paymentMethods']),

          const SizedBox(height: 24),

          // Monthly Spending
          const Text(
            'Monthly Spending Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildSpendingChart(analytics['monthlyData']),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.trending_up, color: color, size: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsChart(Map<String, int> paymentMethods) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: paymentMethods.entries.map((entry) {
            final percentage =
                (entry.value /
                paymentMethods.values.fold(0, (a, b) => a + b) *
                100);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    _getPaymentMethodIcon(entry.key),
                    size: 20,
                    color: primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSpendingChart(List<Map<String, dynamic>> monthlyData) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Simple bar chart representation
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: monthlyData.map((data) {
                  final maxAmount = monthlyData
                      .map((d) => d['amount'] as int)
                      .reduce((a, b) => a > b ? a : b);
                  final height = (data['amount'] as int) / maxAmount * 150;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '₹${data['amount']}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        height: height,
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(data['month'], style: const TextStyle(fontSize: 10)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTransactions(AppState appState) {
    final allTransactions = _getAppTransactions(appState);

    if (_selectedFilter == 'All') {
      return allTransactions;
    }

    return allTransactions.where((transaction) {
      return transaction['status'].toLowerCase() ==
          _selectedFilter.toLowerCase();
    }).toList();
  }

  List<Map<String, dynamic>> _getAppTransactions(AppState appState) {
    final transactions = appState.transactions;

    if (transactions.isEmpty) {
      // Return sample data if no real transactions
      return _getSampleTransactions();
    }

    return transactions.map((transaction) {
      return {
        'orderId': transaction.orderId,
        'date':
            '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}-${transaction.date.day.toString().padLeft(2, '0')}',
        'amount': transaction.amount.toInt(),
        'status': transaction.status,
        'paymentMethod': transaction.paymentMethod,
        'items': transaction.products.length,
        'products': transaction.products,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _getSampleTransactions() {
    return [
      {
        'orderId': 'ORD001',
        'date': '2025-07-02',
        'amount': 1299,
        'status': 'Completed',
        'paymentMethod': 'Credit Card',
        'items': 2,
        'products': ['iPhone 15 Pro', 'Nike Shoes'],
      },
      {
        'orderId': 'ORD002',
        'date': '2025-07-01',
        'amount': 7999,
        'status': 'Completed',
        'paymentMethod': 'UPI',
        'items': 1,
        'products': ['Sony Headphones'],
      },
      {
        'orderId': 'ORD003',
        'date': '2025-06-30',
        'amount': 99999,
        'status': 'Pending',
        'paymentMethod': 'Net Banking',
        'items': 1,
        'products': ['MacBook Air'],
      },
      {
        'orderId': 'ORD004',
        'date': '2025-06-28',
        'amount': 4999,
        'status': 'Failed',
        'paymentMethod': 'Credit Card',
        'items': 1,
        'products': ['Smart Speaker'],
      },
      {
        'orderId': 'ORD005',
        'date': '2025-06-25',
        'amount': 2999,
        'status': 'Refunded',
        'paymentMethod': 'UPI',
        'items': 1,
        'products': ['Nike Shoes'],
      },
    ];
  }

  Map<String, dynamic> _getAnalyticsData(AppState appState) {
    final transactions = _getAppTransactions(appState);
    final completedTransactions = transactions
        .where((t) => t['status'] == 'Completed')
        .toList();

    final totalSpent = completedTransactions.fold(
      0,
      (sum, t) => sum + (t['amount'] as int),
    );
    final totalOrders = completedTransactions.length;
    final averageOrder = totalOrders > 0
        ? (totalSpent / totalOrders).round()
        : 0;

    // This month transactions (July 2025)
    final now = DateTime.now();
    final thisMonthTransactions = completedTransactions
        .where(
          (t) => (t['date'] as String).startsWith(
            '${now.year}-${now.month.toString().padLeft(2, '0')}',
          ),
        )
        .toList();
    final thisMonth = thisMonthTransactions.fold(
      0,
      (sum, t) => sum + (t['amount'] as int),
    );

    // Payment methods count
    final paymentMethods = <String, int>{};
    for (final transaction in completedTransactions) {
      final method = transaction['paymentMethod'] as String;
      paymentMethods[method] = (paymentMethods[method] ?? 0) + 1;
    }

    // Monthly data (sample data for chart)
    final monthlyData = [
      {'month': 'Jan', 'amount': 15000},
      {'month': 'Feb', 'amount': 22000},
      {'month': 'Mar', 'amount': 18000},
      {'month': 'Apr', 'amount': 25000},
      {'month': 'May', 'amount': 20000},
      {'month': 'Jun', 'amount': 30000},
    ];

    return {
      'totalSpent': totalSpent,
      'totalOrders': totalOrders,
      'averageOrder': averageOrder,
      'thisMonth': thisMonth,
      'paymentMethods': paymentMethods,
      'monthlyData': monthlyData,
    };
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'failed':
        return Icons.error;
      case 'refunded':
        return Icons.refresh;
      default:
        return Icons.info;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
        return Icons.credit_card;
      case 'upi':
        return Icons.account_balance_wallet;
      case 'net banking':
        return Icons.account_balance;
      case 'debit card':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${transaction['orderId']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date:', transaction['date']),
            _buildDetailRow('Amount:', '₹${transaction['amount']}'),
            _buildDetailRow('Status:', transaction['status']),
            _buildDetailRow('Payment Method:', transaction['paymentMethod']),
            _buildDetailRow('Items:', '${transaction['items']}'),
            const SizedBox(height: 8),
            const Text(
              'Products:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...((transaction['products'] as List<String>).map(
              (product) => Text('• $product'),
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
