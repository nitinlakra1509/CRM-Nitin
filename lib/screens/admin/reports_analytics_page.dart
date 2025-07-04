import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart' as fl_chart;
import '../../models/app_state.dart';

const primaryBlue = Color(0xFF232F3E);

class ReportsAnalyticsPage extends StatelessWidget {
  const ReportsAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final statusStats = appState.getOrderStatusStats();
    final topProducts = appState.getTopProducts();
    final total = statusStats.values.fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Revenue',
                    '₹${appState.getTotalRevenue().toInt()}',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    '₹${appState.getMonthlyRevenue().toInt()}',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Status Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: statusStats.isEmpty || total == 0
                      ? const Center(child: Text('No data'))
                      : fl_chart.PieChart(
                          fl_chart.PieChartData(
                            sections: statusStats.entries.map((entry) {
                              final percentage = total > 0
                                  ? (entry.value / total * 100)
                                  : 0;
                              return fl_chart.PieChartSectionData(
                                color: _getStatusColor(entry.key),
                                value: entry.value.toDouble(),
                                title:
                                    '${entry.key}\n${percentage.toStringAsFixed(1)}%',
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Top Selling Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 12),
            _buildTopProductsList(topProducts),
            const SizedBox(height: 24),
            const Text(
              'Revenue Trend (Last 6 Months)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildRevenueTrendChart(appState),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Method Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildPaymentMethodChart(appState),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsList(List<Map<String, dynamic>> topProducts) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: topProducts.map((product) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: primaryBlue,
              child: Icon(Icons.star, color: Colors.white, size: 16),
            ),
            title: Text(
              product['name'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${product['count']} sold',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevenueTrendChart(AppState appState) {
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final date = DateTime(now.year, now.month - (5 - i), 1);
      return date;
    });
    final revenues = months.map((month) {
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 1);
      final revenue = appState.orders
          .where(
            (order) =>
                order.orderDate.isAfter(
                  start.subtract(const Duration(days: 1)),
                ) &&
                order.orderDate.isBefore(end) &&
                order.status != 'Cancelled' &&
                order.status != 'Refunded',
          )
          .fold(0.0, (sum, order) => sum + order.totalAmount);
      return revenue;
    }).toList();
    return fl_chart.BarChart(
      fl_chart.BarChartData(
        alignment: fl_chart.BarChartAlignment.spaceAround,
        maxY: (revenues.reduce((a, b) => a > b ? a : b) * 1.2).clamp(
          1,
          double.infinity,
        ),
        barTouchData: fl_chart.BarTouchData(enabled: true),
        titlesData: fl_chart.FlTitlesData(
          leftTitles: fl_chart.AxisTitles(
            sideTitles: fl_chart.SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: fl_chart.AxisTitles(
            sideTitles: fl_chart.SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= months.length) return const SizedBox();
                final m = months[idx];
                return Text(
                  '${m.month}/${m.year % 100}',
                  style: const TextStyle(fontSize: 10),
                );
              },
              interval: 1,
            ),
          ),
          rightTitles: fl_chart.AxisTitles(
            sideTitles: fl_chart.SideTitles(showTitles: false),
          ),
          topTitles: fl_chart.AxisTitles(
            sideTitles: fl_chart.SideTitles(showTitles: false),
          ),
        ),
        borderData: fl_chart.FlBorderData(show: false),
        barGroups: List.generate(
          months.length,
          (i) => fl_chart.BarChartGroupData(
            x: i,
            barRods: [
              fl_chart.BarChartRodData(
                toY: revenues[i],
                color: Colors.blueAccent,
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChart(AppState appState) {
    final methodCounts = <String, int>{};
    for (final order in appState.orders) {
      if (order.status != 'Cancelled' && order.status != 'Refunded') {
        methodCounts[order.paymentMethod] =
            (methodCounts[order.paymentMethod] ?? 0) + 1;
      }
    }
    final total = methodCounts.values.fold(0, (a, b) => a + b);
    if (methodCounts.isEmpty || total == 0) {
      return const Center(child: Text('No data'));
    }
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.cyan,
      Colors.brown,
    ];
    int colorIdx = 0;
    return fl_chart.PieChart(
      fl_chart.PieChartData(
        sections: methodCounts.entries.map((entry) {
          final percentage = total > 0 ? (entry.value / total * 100) : 0;
          final color = colors[colorIdx++ % colors.length];
          return fl_chart.PieChartSectionData(
            color: color,
            value: entry.value.toDouble(),
            title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 30,
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
