import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _category;
  int? _price;

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final iconMap = {
        'Mobiles': Icons.phone_iphone,
        'Electronics': Icons.laptop,
        'Home': Icons.chair,
        'Fashion': Icons.watch,
        'Sports': Icons.sports_soccer,
        'More': Icons.more_horiz,
      };
      Provider.of<AppState>(context, listen: false).addProduct(
        Product(
          name: _name!,
          icon: iconMap[_category] ?? Icons.category,
          price: _price ?? 0,
          category: _category ?? '',
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showAddProductDialog() {
    _category = null;
    showDialog(
      context: context,
      builder: (context) {
        final categories = Provider.of<AppState>(context).categories;
        return AlertDialog(
          title: Text('Add Product'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter name' : null,
                  onSaved: (value) => _name = value,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Category'),
                  value: _category,
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  onSaved: (value) => _category = value,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Select category' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter price' : null,
                  onSaved: (value) => _price = int.tryParse(value ?? '0'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(onPressed: _addProduct, child: Text('Add')),
          ],
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    Provider.of<AppState>(context, listen: false).removeProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<AppState>(context).products;
    return Scaffold(
      appBar: AppBar(title: Text('Manage Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Category: (see icon)'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteProduct(product),
            ),
            leading: Icon(product.icon),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }
}
