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
    String title = banner?.title ?? '';
    String link = banner?.link ?? '';

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
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter title' : null,
                  onSaved: (v) => title = v ?? '',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: link,
                  decoration: const InputDecoration(labelText: 'Link'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter link' : null,
                  onSaved: (v) => link = v ?? '',
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
                final adBanner = AdBanner(
                  imageUrl: imageUrl,
                  title: title,
                  link: link,
                );
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
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 40),
                  title: Text(banner.title),
                  subtitle: Text(banner.link),
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
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Banner'),
                              content: const Text(
                                'Are you sure you want to delete this banner?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Provider.of<AppState>(
                                      context,
                                      listen: false,
                                    ).deleteAdBanner(i);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        tooltip: 'Delete',
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
        tooltip: 'Create Ad Banner',
      ),
    );
  }
}
