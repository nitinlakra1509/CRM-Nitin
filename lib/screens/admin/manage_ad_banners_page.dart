import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class ManageAdBannersPage extends StatelessWidget {
  const ManageAdBannersPage({Key? key}) : super(key: key);

  Future<void> _pickAdImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      Provider.of<AppState>(context, listen: false).setAdImage(bytes);
    }
  }

  void _showBannerDialog(
    BuildContext context, {
    int? editIndex,
    AdBanner? banner,
  }) {
    final appState = Provider.of<AppState>(context, listen: false);
    Uint8List? adImage = appState.adImage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            editIndex == null ? 'Create Ad Banner' : 'Edit Ad Banner',
          ),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      final bytes = await picked.readAsBytes();
                      setState(() {
                        adImage = bytes;
                      });
                      appState.setAdImage(bytes);
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (adImage != null)
                  SizedBox(
                    height: 120,
                    child: Image.memory(adImage!, fit: BoxFit.contain),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (adImage != null) {
                  // You can optionally create a model for in-memory ad banners
                  // For now, just close dialog after setting image
                  Navigator.pop(context);
                }
              },
              child: Text(editIndex == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Ad Banners')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final adImage = appState.adImage;
          return Center(
            child: adImage != null
                ? Card(
                    child: SizedBox(
                      height: 120,
                      child: Image.memory(adImage, fit: BoxFit.contain),
                    ),
                  )
                : const Text('No Ad Image Selected'),
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
