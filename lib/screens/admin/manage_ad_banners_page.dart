import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class ManageAdBannersPage extends StatelessWidget {
  const ManageAdBannersPage({Key? key}) : super(key: key);

  void _showBannerDialog(
    BuildContext context, {
    int? editIndex,
    AdBanner? banner,
  }) {
    final _formKey = GlobalKey<FormState>();
    String imageUrl = banner?.imageUrl ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editIndex == null ? 'Create Ad Banner' : 'Edit Ad Banner'),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: imageUrl,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter image URL' : null,
                  onSaved: (v) => imageUrl = v ?? '',
                ),
                const SizedBox(height: 12),
                if (imageUrl.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final adBanner = AdBanner(imageUrl: imageUrl);
                final appState = Provider.of<AppState>(context, listen: false);
                if (editIndex == null) {
                  appState.addAdBanner(adBanner);
                } else {
                  appState.updateAdBanner(editIndex, adBanner);
                }
                Navigator.pop(context);
              }
            },
            child: Text(editIndex == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Ad Banners')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final banners = appState.adBanners;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: banners.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final banner = banners[i];
              return Card(
                child: ListTile(
                  leading: banner.imageUrl.isNotEmpty
                      ? Image.network(
                          banner.imageUrl,
                          width: 120,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 40),
                  title: null,
                  subtitle: null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showBannerDialog(
                          context,
                          editIndex: i,
                          banner: banner,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<AppState>(
                            context,
                            listen: false,
                          ).deleteAdBanner(i);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBannerDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Ad Banner',
      ),
    );
  }
}
