import 'package:flutter/material.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  _ManageCategoriesPageState createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  List<String> categories = ['Mobiles', 'Electronics', 'Home'];
  final _formKey = GlobalKey<FormState>();
  String? _categoryName;

  void _addCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        categories.add(_categoryName!);
      });
      Navigator.pop(context);
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Category'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Category Name'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter name' : null,
            onSaved: (value) => _categoryName = value,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(onPressed: _addCategory, child: Text('Add')),
        ],
      ),
    );
  }

  void _deleteCategory(String name) {
    setState(() {
      categories.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Categories')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteCategory(category),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }
}
