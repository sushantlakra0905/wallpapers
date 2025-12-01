//wallpaper_controller.dart

import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/wallpaper_model.dart';
import '../services/image_service.dart';
import '../services/local_storage.dart';
import '../services/wallpaper_service.dart';

class WallpaperController {
  final LocalStorage _localStorage = LocalStorage();
  final ImageService _imageService = ImageService();
  final Random _random = Random();

  List<WallpaperImage> _images = [];
  AppStats _stats = AppStats(
    totalImages: 0,
    lastWallpaperSet: DateTime.now(),
    totalWallpapersSet: 0,
  );

  List<WallpaperImage> get images => _images;
  AppStats get stats => _stats;

  Future<void> initialize() async {
    await _loadImages();
    await _loadStats();
  }

  Future<void> _loadImages() async {
    _images = await _localStorage.loadImages();
  }

  Future<void> _loadStats() async {
    _stats = await _localStorage.loadStats();
  }

  Future<void> _saveImages() async {
    await _localStorage.saveImages(_images);
  }

  Future<void> _saveStats() async {
    await _localStorage.saveStats(_stats);
  }

  // *************** NEW: Permanent Storage Copy ***************
  Future<File> _saveToPermanentStorage(File originalFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final wallpapersDir = Directory('${appDir.path}/wallpapers');

    if (!wallpapersDir.existsSync()) {
      wallpapersDir.createSync(recursive: true);
    }

    final fileName = originalFile.path.split('/').last;
    final savedFile = File('${wallpapersDir.path}/$fileName');

    // avoid overwriting: append timestamp if exists
    if (savedFile.existsSync()) {
      final newFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${fileName}';
      return originalFile.copy('${wallpapersDir.path}/$newFileName');
    }

    return originalFile.copy(savedFile.path);
  }
  // ***********************************************************

  Future<void> addImage(File imageFile) async {
    try {
      // save to permanent folder
      final savedFile = await _saveToPermanentStorage(imageFile);

      final fileSize = await _imageService.getFileSize(savedFile);
      final fileName = _imageService.getFileName(savedFile.path);

      final newImage = WallpaperImage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: savedFile.path, // UPDATED
        fileName: fileName,
        addedDate: DateTime.now(),
        fileSize: fileSize,
      );

      _images.add(newImage);
      _stats = AppStats(
        totalImages: _images.length,
        lastWallpaperSet: _stats.lastWallpaperSet,
        totalWallpapersSet: _stats.totalWallpapersSet,
      );

      await _saveImages();
      await _saveStats();
    } catch (e) {
      throw Exception('Failed to add image: $e');
    }
  }

  Future<void> addMultipleImages(List<File> imageFiles) async {
    try {
      for (final imageFile in imageFiles) {
        final savedFile = await _saveToPermanentStorage(imageFile);

        final fileSize = await _imageService.getFileSize(savedFile);
        final fileName = _imageService.getFileName(savedFile.path);

        final newImage = WallpaperImage(
          id: '${DateTime.now().millisecondsSinceEpoch}_${_images.length}',
          filePath: savedFile.path, // UPDATED
          fileName: fileName,
          addedDate: DateTime.now(),
          fileSize: fileSize,
        );

        _images.add(newImage);
      }

      _stats = AppStats(
        totalImages: _images.length,
        lastWallpaperSet: _stats.lastWallpaperSet,
        totalWallpapersSet: _stats.totalWallpapersSet,
      );

      await _saveImages();
      await _saveStats();
    } catch (e) {
      throw Exception('Failed to add images: $e');
    }
  }

  Future<bool> setRandomWallpaper() async {
    if (_images.isEmpty) return false;

    final randomImage = getRandomImage();
    if (randomImage == null) return false;

    try {
      await WallpaperService.setHomeScreen(randomImage.filePath);
      await _saveStats();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeImage(String imageId) async {
    _images.removeWhere((image) => image.id == imageId);

    _stats = AppStats(
      totalImages: _images.length,
      lastWallpaperSet: _stats.lastWallpaperSet,
      totalWallpapersSet: _stats.totalWallpapersSet,
    );

    await _saveImages();
    await _saveStats();
  }

  Future<void> clearAllImages() async {
    _images.clear();
    _stats = AppStats(
      totalImages: 0,
      lastWallpaperSet: _stats.lastWallpaperSet,
      totalWallpapersSet: _stats.totalWallpapersSet,
    );

    await _saveImages();
    await _saveStats();
  }

  WallpaperImage? getRandomImage() {
    if (_images.isEmpty) return null;

    final randomIndex = _random.nextInt(_images.length);
    final selectedImage = _images[randomIndex];

    _stats = AppStats(
      totalImages: _stats.totalImages,
      lastWallpaperSet: DateTime.now(),
      totalWallpapersSet: _stats.totalWallpapersSet + 1,
    );

    _saveStats();
    return selectedImage;
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
