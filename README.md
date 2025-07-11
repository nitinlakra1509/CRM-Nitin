# Nitin E-Commerce Flutter App

A comprehensive Flutter e-commerce application with advanced admin and user features, built for modern shopping experiences.

## 🚀 Features

### User Features
- **Modern Dashboard** with ad banners carousel and product grid
- **Product Browsing** with categories and search functionality
- **Shopping Cart** with quantity management
- **Wishlist** for favorite products
- **Payment History** with analytics and transaction tracking
- **User Profile** management and settings
- **Order Tracking** and history

### Admin Features
- **Admin Dashboard** with comprehensive management tools
- **Product Management** - Add, edit, delete products
- **Category Management** - Organize product categories
- **Order Management** - Track and update order status with bulk actions
- **Ad Banner Management** - Create and manage promotional banners
- **Reports & Analytics** - Business insights and metrics
- **User Management** - Customer administration

### Technical Features
- **State Management** using Provider pattern
- **Modern UI/UX** with Material Design 3
- **Image Loading** with shimmer effects
- **Payment Integration** ready architecture
- **Responsive Design** for various screen sizes
- **Error Handling** and validation

## 📱 Screenshots

### User Interface
- **Dashboard**: Featured products, categories, and promotional banners
- **Product Details**: Comprehensive product information and specifications
- **Shopping Cart**: Easy cart management with quantity controls
- **Payment History**: Transaction tracking with analytics

### Admin Interface
- **Admin Dashboard**: Central hub for all management tasks
- **Order Management**: Advanced filtering, bulk actions, and status updates
- **Product Management**: Complete CRUD operations for products
- **Analytics Dashboard**: Business metrics and reporting

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **UI Components**: Material Design 3
- **Image Loading**: Shimmer package
- **Platform**: Android, iOS, Web, Desktop

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  shimmer: ^3.0.0
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/nitin-ecommerce-app.git
   cd nitin-ecommerce-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── app_state.dart       # Global state management
│   └── customer.dart        # Customer model
├── screens/
│   ├── admin/               # Admin panel screens
│   │   ├── admin_dashboard_page.dart
│   │   ├── manage_products_page.dart
│   │   ├── manage_orders_page.dart
│   │   ├── manage_categories_page.dart
│   │   ├── manage_ad_banners_page.dart
│   │   └── reports_analytics_page.dart
│   ├── user/                # User-specific screens
│   ├── dashboard_page.dart  # Main user dashboard
│   ├── payment_history_page.dart
│   ├── carts_page.dart
│   └── login_page.dart
└── widgets/
    └── customer_tile.dart   # Reusable components
```

## 🎯 Key Features Implemented

### Order Management System
- **Status Tracking**: Pending, Processing, Shipped, Delivered, Cancelled
- **Bulk Operations**: Multi-select and batch status updates
- **Advanced Filtering**: Filter by status with counts
- **Export Functionality**: CSV export for order data

### Ad Banner System
- **Dynamic Banners**: Admin can create/edit/delete promotional banners
- **Carousel Display**: Smooth image carousel on user dashboard
- **Fallback Content**: Attractive placeholder when no ads are available
- **Image Loading**: Shimmer effects during image load

### Payment & Analytics
- **Transaction History**: Complete payment tracking
- **Analytics Dashboard**: Revenue metrics and trends
- **Payment Methods**: Support for multiple payment options
- **Receipt Generation**: Downloadable transaction receipts

## 🔧 Configuration

### App State Configuration
The app uses a centralized state management system. Key configurations:

- **Products**: Sample products with categories and pricing
- **Orders**: Order tracking and management
- **Payment Methods**: UPI, Credit Card, Net Banking, COD
- **User Settings**: Dark mode, notifications, preferences

### Admin Access
- Default admin credentials for development
- Role-based access control
- Secure admin panel navigation

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# APK located at: build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios --release
# Follow iOS deployment guidelines
```

### Web
```bash
flutter build web --release
# Deploy the build/web folder to your web server
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit changes (`git commit -m 'Add new feature'`)
4. Push to branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Nitin** - Flutter Developer
- GitHub: [@your-username](https://github.com/your-username)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Provider package for state management
- Community plugins and packages

---

**Built with ❤️ using Flutter**