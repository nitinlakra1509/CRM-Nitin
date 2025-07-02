import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/dashboard_page.dart';
import 'screens/carts_page.dart';
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
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const DashboardPage(),
    const CartsPage(),
    const PaymentHistoryPage(),
    const UserAccountPage(),
  ];

  static const List<String> _titles = [
    '', // Dashboard has no AppBar
    'Carts',
    'Payments',
    'Account',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              title: Text(_titles[_selectedIndex]),
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: accentYellow,
        unselectedItemColor: Colors.white,
        backgroundColor: primaryBlue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Payment History will be shown here"));
  }
}
