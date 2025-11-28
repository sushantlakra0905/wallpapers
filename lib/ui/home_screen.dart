import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_picker/ui/wallpaper_preview.dart';
import 'package:wallpaper_picker/ui/widgets/action_butttons.dart';
import 'package:wallpaper_picker/ui/widgets/stats_card.dart';
import '../controllers/wallpaper_controller.dart';
import '../services/image_service.dart';
import '../services/wallpaper_service.dart';
import 'image_grid.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WallpaperController _controller = WallpaperController();
  final ImageService _imageService = ImageService();
  bool _isLoading = true;
  bool _isAddingMultiple = false;
  bool _autoDaily = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _controller.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  /// Toggle auto daily wallpaper change
  void _toggleDailyAutoChange(bool value) async {
    setState(() => _autoDaily = value);

    if (value) {
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1, // Unique ID
        _dailyWallpaperCallback,
        wakeup: true,
        rescheduleOnReboot: true,
      );
      _showSnackBar("Daily auto-change enabled!");
    } else {
      await AndroidAlarmManager.cancel(1);
      _showSnackBar("Daily auto-change disabled.");
    }
  }

  /// Background callback
  static void _dailyWallpaperCallback() async {
    final controller = WallpaperController();
    await controller.initialize();
    final randomImage = controller.getRandomImage();
    if (randomImage != null) {
      await WallpaperService.setHomeScreen(randomImage.filePath);
    }
  }

  /// Add photos (single + multiple combined)
  Future<void> _handleAddPhotos() async {
    try {
      setState(() => _isAddingMultiple = true);

      final imageFiles = await _imageService.pickMultipleImages();
      if (imageFiles.isNotEmpty) {
        await _controller.addMultipleImages(imageFiles);
        setState(() {});
        _showSnackBar('${imageFiles.length} images added successfully!');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('permission')) {
        _showPermissionDeniedDialog();
      } else {
        _showSnackBar('Error: $e');
      }
    } finally {
      setState(() => _isAddingMultiple = false);
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This app needs access to your photos to select wallpapers. '
              'Please grant the permission in app settings.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Open Settings')),
        ],
      ),
    );
  }

  Future<void> _handleRemoveImage(String imageId) async {
    await _controller.removeImage(imageId);
    setState(() {});
    _showSnackBar('Image removed');
  }

  Future<void> _handleClearAll() async {
    if (_controller.images.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Images?'),
        content: Text('This will remove all ${_controller.images.length} images.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _controller.clearAllImages();
              setState(() {});
              _showSnackBar('All images cleared');
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Random wallpaper → Preview
  Future<void> _handleRandomWallpaper() async {
    final randomImage = _controller.getRandomImage();
    if (randomImage == null) {
      _showSnackBar('Please add some images first!');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperPreview(image: randomImage, controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Wallpaper'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          if (_controller.images.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _handleClearAll,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          StatsCard(stats: _controller.stats),

          /// Single Add Photos + Random button
          ActionButtons(
            onAddMultipleImages: _handleAddPhotos,
            onRandomWallpaper: _handleRandomWallpaper,
            isLoading: _isAddingMultiple,
          ),

          const SizedBox(height: 16),

          if (_isAddingMultiple)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Adding images...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

          SwitchListTile(
            title: const Text("Auto Change Daily"),
            subtitle: const Text("Automatically sets a random wallpaper every 24 hours"),
            value: _autoDaily,
            onChanged: _toggleDailyAutoChange,
          ),

          Expanded(
            child: ImageGrid(
              images: _controller.images,
              onRemoveImage: _handleRemoveImage,
              onImageTap: (image) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WallpaperPreview(image: image, controller: _controller),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
