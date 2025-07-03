import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import '../../models/app_state.dart';

class InMemoryAdBanner {
  Uint8List image;
  InMemoryAdBanner({required this.image});
}

class ManageAdBannersPage extends StatefulWidget {
  const ManageAdBannersPage({Key? key}) : super(key: key);

  @override
  State<ManageAdBannersPage> createState() => _ManageAdBannersPageState();
}

class _ManageAdBannersPageState extends State<ManageAdBannersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Ad Banners')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final banners = appState.adImages;
          if (banners.isEmpty) {
            return const Center(child: Text('No Ad Banners'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: ReorderableColumn(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                needsLongPressDraggable: true,
                onReorder: (oldIndex, newIndex) {
                  appState.reorderAdImage(oldIndex, newIndex);
                },
                children: List.generate(banners.length, (i) {
                  final banner = banners[i];
                  return Card(
                    key: ValueKey('banner_$i'),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.memory(banner, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _showBannerDialog(context, editIndex: i),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => appState.deleteAdImage(i),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.drag_handle, color: Colors.grey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
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

  void _showBannerDialog(BuildContext context, {int? editIndex}) {
    final appState = Provider.of<AppState>(context, listen: false);
    Uint8List? tempImage = editIndex != null
        ? appState.adImages[editIndex]
        : null;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(editIndex == null ? 'Add Ad Banner' : 'Edit Ad Banner'),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(
                    editIndex == null ? 'Pick Image' : 'Replace Image',
                  ),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      final bytes = await picked.readAsBytes();
                      setStateDialog(() {
                        tempImage = bytes;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (tempImage != null)
                  SizedBox(
                    height: 120,
                    child: Image.memory(tempImage!, fit: BoxFit.contain),
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
                if (tempImage != null) {
                  if (editIndex != null) {
                    appState.updateAdImage(editIndex, tempImage!);
                  } else {
                    appState.addAdImage(tempImage!);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(editIndex == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
