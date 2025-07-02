import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class ManageCategoriesPage extends StatelessWidget {
  ManageCategoriesPage({super.key});
  final _formKey = GlobalKey<FormState>();

  void _showAddCategoryDialog(BuildContext context) {
    String? categoryName;
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
            onSaved: (value) => categoryName = value,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (categoryName != null && categoryName!.isNotEmpty) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).addCategory(categoryName!);
                }
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<AppState>(context).categories;
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
              onPressed: () {
                Provider.of<AppState>(
                  context,
                  listen: false,
                ).removeCategory(category);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }
}
