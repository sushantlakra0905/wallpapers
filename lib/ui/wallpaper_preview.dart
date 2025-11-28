//wallpaper_preview.dart

import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../models/wallpaper_model.dart';
import '../controllers/wallpaper_controller.dart';
import '../services/simple_wallpaper_handler.dart';

class WallpaperPreview extends StatefulWidget {
  final WallpaperImage image;
  final WallpaperController controller;

  const WallpaperPreview({
    super.key,
    required this.image,
    required this.controller,
  });

  @override
  State<WallpaperPreview> createState() => _WallpaperPreviewState();
}

class _WallpaperPreviewState extends State<WallpaperPreview> {
  bool _isSettingWallpaper = false;

  Future<void> _setWallpaper(int location) async {
    setState(() {
      _isSettingWallpaper = true;
    });

    try {
      final file = File(widget.image.filePath);

      if (!file.existsSync()) {
        _showSnackBar("Image file not found.");
        return;
      }

      // Request permissions
      await Permission.storage.request();
      await Permission.photos.request();

      bool result = await WallpaperManager.setWallpaperFromFile(
        file.path,
        location,
      );

      if (result) {
        _showSnackBar("Wallpaper set successfully!");
        Navigator.pop(context);
      } else {
        _showSnackBar("Failed to set wallpaper.");
      }

    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      if (mounted) {
        setState(() => _isSettingWallpaper = false);
      }
    }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set as Wallpaper',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWallpaperOption(
              icon: Icons.home,
              title: 'Home Screen',
              subtitle: 'Set as home screen wallpaper',
              onTap: () => _setWallpaper(WallpaperManager.HOME_SCREEN),
            ),
            _buildWallpaperOption(
              icon: Icons.lock,
              title: 'Lock Screen',
              subtitle: 'Set as lock screen wallpaper',
              onTap: () => _setWallpaper(WallpaperManager.LOCK_SCREEN),
            ),
            _buildWallpaperOption(
              icon: Icons.phone_android,
              title: 'Both Screens',
              subtitle: 'Set as both home and lock screen',
              onTap: () => _setWallpaper(WallpaperManager.BOTH_SCREEN),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'The image will be saved and prepared for use as wallpaper.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper Preview'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (!_isSettingWallpaper)
            IconButton(
              icon: const Icon(Icons.wallpaper),
              onPressed: _showWallpaperOptions,
              tooltip: 'Set Wallpaper',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(widget.image.filePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 50),
                              SizedBox(height: 16),
                              Text('Failed to load image'),
                            ],
                          ),
                        );
                      },
                    ),
                    if (_isSettingWallpaper)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Setting Wallpaper...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Please wait',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.image.fileName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Added: ${_formatDate(widget.image.addedDate)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Size: ${widget.controller.formatFileSize(widget.image.fileSize)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_isSettingWallpaper)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showWallpaperOptions,
                      icon: const Icon(Icons.wallpaper),
                      label: const Text(
                        'Set as Wallpaper',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}