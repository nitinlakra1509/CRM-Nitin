import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'order_history_page.dart';
import 'wishlist_page.dart';
import 'settings_page.dart';
import 'help_support_page.dart';
import '../login_page.dart';

class UserAccountPage extends StatelessWidget {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 64, color: Color(0xFF232F3E)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nitin Lakra',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF232F3E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'nitin@email.com',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.edit, color: Color(0xFF232F3E)),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF232F3E)),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF232F3E)),
            title: const Text('Order History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Color(0xFF232F3E)),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF232F3E)),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Color(0xFF232F3E)),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
