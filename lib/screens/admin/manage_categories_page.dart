import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class ManageCategoriesPage extends StatelessWidget {
  ManageCategoriesPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final List<IconData> _iconOptions = [
    Icons.category,
    Icons.phone_android,
    Icons.tv,
    Icons.home,
    Icons.laptop,
    Icons.kitchen,
    Icons.chair,
    Icons.watch,
  ];

  void _showAddCategoryDialog(BuildContext context) {
    String? categoryName;
    IconData? selectedIcon;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Category'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
                onSaved: (value) => categoryName = value,
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _iconOptions.map((icon) {
                  return StatefulBuilder(
                    builder: (context, setState) => IconButton(
                      icon: Icon(
                        icon,
                        color: selectedIcon == icon ? Colors.blue : null,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              if (selectedIcon == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Select an icon',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && selectedIcon != null) {
                _formKey.currentState!.save();
                if (categoryName != null && categoryName!.isNotEmpty) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).addCategoryWithIcon(categoryName!, selectedIcon!);
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

  void _showEditCategoryDialog(
    BuildContext context,
    int index,
    String currentName,
    IconData currentIcon,
  ) {
    String? categoryName = currentName;
    IconData? selectedIcon = currentIcon;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: currentName,
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
                onSaved: (value) => categoryName = value,
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _iconOptions.map((icon) {
                  return StatefulBuilder(
                    builder: (context, setState) => IconButton(
                      icon: Icon(
                        icon,
                        color: selectedIcon == icon ? Colors.blue : null,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              if (selectedIcon == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Select an icon',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && selectedIcon != null) {
                _formKey.currentState!.save();
                if (categoryName != null && categoryName!.isNotEmpty) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).editCategory(index, categoryName!, selectedIcon!);
                }
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<AppState>(context).categoriesWithIcons;
    return Scaffold(
      appBar: AppBar(title: Text('Manage Categories')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: Icon(category['icon'] ?? Icons.category),
            title: Text(category['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditCategoryDialog(
                    context,
                    index,
                    category['name'],
                    category['icon'] ?? Icons.category,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<AppState>(
                      context,
                      listen: false,
                    ).removeCategory(category['name']);
                  },
                ),
              ],
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
