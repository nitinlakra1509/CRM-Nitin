import 'package:flutter/material.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  List<Map<String, dynamic>> products = [
    {'id': 1, 'name': 'Sample Product', 'category': 'Mobiles'},
  ];

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _category;

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        products.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': _name!,
          'category': _category ?? 'Uncategorized',
        });
      });
      Navigator.pop(context);
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                onSaved: (value) => _category = value,
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
      ),
    );
  }

  void _deleteProduct(int id) {
    setState(() {
      products.removeWhere((p) => p['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Category: ${product['category']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteProduct(product['id']),
            ),
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
