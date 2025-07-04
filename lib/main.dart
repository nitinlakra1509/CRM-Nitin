import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/dashboard_page.dart';
import 'screens/carts_page.dart';
import 'screens/payment_history_page.dart'; // We'll rename this file later
import 'screens/user/user_account_page.dart';
import 'screens/login_page.dart';

const primaryBlue = Color(0xFF232F3E);
const accentYellow = Color.fromARGB(255, 80, 114, 138);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const NitinCRMApp(),
    ),
  );
}

class NitinCRMApp extends StatelessWidget {
  const NitinCRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryBlue,
          secondary: accentYellow,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.dark().copyWith(
          primary: primaryBlue,
          secondary: accentYellow,
          surface: const Color(0xFF232F3E),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF181A20),
        cardColor: const Color(0xFF232F3E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF232F3E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: Colors.white70,
          ),
          titleLarge: TextStyle(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF232F3E),
          selectedItemColor: accentYellow,
          unselectedItemColor: Colors.white70,
        ),
      ),
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<Widget> _pages = [
    const DashboardPage(),
    const CartsPage(),
    const PaymentHistoryPage(),
    const UserAccountPage(),
  ];

  static const List<String> _titles = [
    '', // Dashboard has no AppBar
    'Carts',
    'Orders',
    'Account',
  ];

  void _onItemTapped(int index) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.switchToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedIndex = appState.selectedTabIndex;

    return Scaffold(
      appBar: selectedIndex == 0
          ? null
          : AppBar(
              title: Text(_titles[selectedIndex]),
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: accentYellow,
        unselectedItemColor: Colors.white,
        backgroundColor: primaryBlue,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: _buildCartIcon(appState),
            label: 'Carts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildCartIcon(AppState appState) {
    final itemCount = appState.cartItemCount;

    return Stack(
      children: [
        const Icon(Icons.shopping_cart),
        if (itemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                itemCount > 99 ? '99+' : '$itemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
