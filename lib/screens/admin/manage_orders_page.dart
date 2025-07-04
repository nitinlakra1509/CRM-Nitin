import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

const primaryBlue = Color(0xFF232F3E);
const accentYellow = Color.fromARGB(255, 80, 114, 138);

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
    'Refunded',
  ];

  // --- MULTI-SELECT STATE ---
  final Set<String> _selectedOrderIds = {};

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
      } else {
        _selectedOrderIds.add(orderId);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = _getFilteredOrders(appState);
    final statusStats = appState.getOrderStatusStats();
    final allStatuses = _filterOptions.where((s) => s != 'All').toList();
    final allSelected =
        orders.isNotEmpty && _selectedOrderIds.length == orders.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Orders refreshed'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Refresh Orders',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section with Search and Filter
          _HeaderSection(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedFilter: _selectedFilter,
            filterOptions: _filterOptions,
            allStatuses: allStatuses,
            statusStats: statusStats,
            onFilterChanged: (val) => setState(() => _selectedFilter = val),
            onBulkActions: _showBulkActionsDialog,
            allSelected: allSelected,
            onSelectAllChanged: (checked) {
              setState(() {
                if (checked) {
                  _selectedOrderIds.addAll(orders.map((o) => o.orderId));
                } else {
                  _selectedOrderIds.removeAll(orders.map((o) => o.orderId));
                }
              });
            },
          ),
          // Orders List
          Expanded(
            child: _OrdersList(
              orders: orders,
              selectedOrderIds: _selectedOrderIds,
              onOrderSelect: _toggleOrderSelection,
              onOrderTap: (order) => _showOrderDetails(order, appState),
              onUpdateStatus: (order) =>
                  _showUpdateStatusDialog(order, appState),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to filter orders based on search and filter criteria
  List<Order> _getFilteredOrders(AppState appState) {
    List<Order> orders = appState.getOrdersByStatus(_selectedFilter);

    if (_searchQuery.isNotEmpty) {
      orders = orders.where((order) {
        final searchLower = _searchQuery.toLowerCase();
        return order.orderId.toLowerCase().contains(searchLower) ||
            order.products.any(
              (product) => product.name.toLowerCase().contains(searchLower),
            ) ||
            order.paymentMethod.toLowerCase().contains(searchLower) ||
            order.status.toLowerCase().contains(searchLower) ||
            (order.deliveryAddress?.toLowerCase().contains(searchLower) ??
                false);
      }).toList();
    }

    return orders;
  }

  // --- Dialogs and Actions ---
  void _showUpdateStatusDialog(Order order, AppState appState) {
    final List<String> allStatuses = [
      'Pending',
      'Processing',
      'Shipped',
      'Delivered',
      'Cancelled',
      'Refunded',
    ];
    final List<String> availableStatuses = allStatuses
        .where((s) => s != order.status)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Order #${order.orderId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Status: ${order.status}'),
            const SizedBox(height: 16),
            const Text('Select new status:'),
            const SizedBox(height: 8),
            ...availableStatuses.map(
              (status) => ListTile(
                leading: Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                ),
                title: Text(status),
                onTap: () async {
                  appState.updateOrderStatus(order.orderId, status);
                  await appState.save();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order status updated to $status'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Order order, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    _getStatusIcon(order.status),
                    color: _getStatusColor(order.status),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Order #${order.orderId}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),

              // Order Info
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        'Order Date:',
                        _formatDate(order.orderDate),
                      ),
                      _buildDetailRow('Status:', order.status),
                      _buildDetailRow('Payment Method:', order.paymentMethod),
                      _buildDetailRow(
                        'Total Amount:',
                        '₹${order.totalAmount.toInt()}',
                      ),
                      if (order.deliveryAddress != null)
                        _buildDetailRow(
                          'Delivery Address:',
                          order.deliveryAddress!,
                        ),

                      const SizedBox(height: 16),
                      const Text(
                        'Products:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...order.products.map(
                        (product) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(product.icon, color: primaryBlue),
                            title: Text(product.name),
                            trailing: Text('₹${product.price}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              const Divider(),
              Row(
                children: [
                  if (_canUpdateStatus(order.status))
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showUpdateStatusDialog(order, appState);
                        },
                        child: const Text('Update Status'),
                      ),
                    ),
                  if (_canUpdateStatus(order.status)) const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  // --- Bulk Actions ---
  void _showBulkActionsDialog() {
    final List<String> allStatuses = [
      'Pending',
      'Processing',
      'Shipped',
      'Delivered',
      'Cancelled',
      'Refunded',
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...allStatuses.map(
              (status) => ListTile(
                leading: Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                ),
                title: Text('Set all to $status'),
                onTap: () {
                  Navigator.pop(context);
                  _bulkUpdateAllToStatus(status);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.purple),
              title: const Text('Export Orders to CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportOrdersToCSV();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _bulkUpdateAllToStatus(String toStatus) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final orders = _selectedOrderIds.isNotEmpty
        ? appState.orders
              .where((o) => _selectedOrderIds.contains(o.orderId))
              .toList()
        : appState.orders;
    for (final order in orders) {
      appState.updateOrderStatus(order.orderId, toStatus);
    }
    await appState.save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated ${orders.length} orders to $toStatus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportOrdersToCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV export feature coming soon!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // --- STATUS/ICON/HELPER METHODS ---
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'processing':
        return Icons.autorenew;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'refunded':
        return Icons.refresh;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _canUpdateStatus(String status) {
    return ['Pending', 'Processing', 'Shipped'].contains(status);
  }
}

// --- Header Section Widget ---
class _HeaderSection extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedFilter;
  final List<String> filterOptions;
  final List<String> allStatuses;
  final Map<String, int> statusStats;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onBulkActions;
  final bool allSelected;
  final ValueChanged<bool> onSelectAllChanged;

  const _HeaderSection({
    required this.searchController,
    required this.searchQuery,
    required this.selectedFilter,
    required this.filterOptions,
    required this.allStatuses,
    required this.statusStats,
    required this.onFilterChanged,
    required this.onBulkActions,
    required this.allSelected,
    required this.onSelectAllChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search orders by ID, product, or customer...',
                prefixIcon: Icon(Icons.search, color: primaryBlue),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Status Chips Row
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allStatuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final status = allStatuses[i];
                final count = statusStats[status] ?? 0;
                final selected = selectedFilter == status;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(status),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  selected: selected,
                  selectedColor: _getStatusColor(status).withOpacity(0.2),
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: selected ? _getStatusColor(status) : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (_) => onFilterChanged(status),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Filter dropdown row
          Row(
            children: [
              const Text(
                'Filter by Status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilterDropdown(
                  selectedFilter: selectedFilter,
                  filterOptions: filterOptions,
                  onChanged: onFilterChanged,
                ),
              ),
              const SizedBox(width: 8),
              Checkbox(
                value: allSelected,
                onChanged: (checked) => onSelectAllChanged(checked ?? false),
              ),
              IconButton(
                onPressed: onBulkActions,
                icon: const Icon(Icons.more_vert),
                tooltip: 'Bulk Actions',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}

class _FilterDropdown extends StatelessWidget {
  final String selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.selectedFilter,
    required this.filterOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: selectedFilter,
        icon: const Icon(Icons.arrow_drop_down, size: 18),
        underline: const SizedBox(),
        isExpanded: true,
        onChanged: (String? newValue) {
          if (newValue != null) onChanged(newValue);
        },
        items: filterOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
      ),
    );
  }
}

// --- Orders List Widget ---
class _OrdersList extends StatelessWidget {
  final List<Order> orders;
  final Set<String> selectedOrderIds;
  final ValueChanged<String> onOrderSelect;
  final void Function(Order) onOrderTap;
  final void Function(Order) onUpdateStatus;

  const _OrdersList({
    required this.orders,
    required this.selectedOrderIds,
    required this.onOrderSelect,
    required this.onOrderTap,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return _EmptyState();
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Stack(
          children: [
            _OrderCard(
              order: order,
              selected: selectedOrderIds.contains(order.orderId),
              onSelect: () => onOrderSelect(order.orderId),
              onTap: () => onOrderTap(order),
              onUpdateStatus: () => onUpdateStatus(order),
            ),
          ],
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onTap;
  final VoidCallback onUpdateStatus;

  const _OrderCard({
    required this.order,
    required this.selected,
    required this.onSelect,
    required this.onTap,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16, // Reduce left padding to make space for checkbox
            right: 16,
            top: 16,
            bottom: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox for this order
              Checkbox(value: selected, onChanged: (_) => onSelect()),
              const SizedBox(width: 8),
              // Card Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Order ID, Date, and Status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              order.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getStatusIcon(order.status),
                            color: _getStatusColor(order.status),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Order #${order.orderId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (_isUrgentOrder(order))
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'URGENT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                _formatDate(order.orderDate),
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
                              '₹${order.totalAmount.toInt()}',
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
                                color: _getStatusColor(order.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.status,
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

                    // Products preview
                    if (order.products.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              order.products.first.icon,
                              size: 16,
                              color: primaryBlue,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                order.products.length == 1
                                    ? order.products.first.name
                                    : '${order.products.first.name} +${order.products.length - 1} more',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Payment Method, Items Count, and Actions Row
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          order.paymentMethod,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${order.products.length} items',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_canUpdateStatus(order.status))
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                            ),
                            onPressed: onUpdateStatus,
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'processing':
        return Icons.autorenew;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'refunded':
        return Icons.refresh;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _canUpdateStatus(String status) {
    return ['Pending', 'Processing', 'Shipped'].contains(status);
  }

  bool _isUrgentOrder(Order order) {
    final now = DateTime.now();
    final timeDifference = now.difference(order.orderDate);
    return order.status == 'Pending' && timeDifference.inHours <= 2;
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
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
            'Orders will appear here when customers place them',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
