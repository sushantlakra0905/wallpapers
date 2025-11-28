import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/wallpaper_model.dart';

class LocalStorage {
  static const String _imagesKey = 'wallpaper_images';
  static const String _statsKey = 'app_stats';

  Future<void> saveImages(List<WallpaperImage> images) async {
    final prefs = await SharedPreferences.getInstance();
    final imagesJson = images.map((image) => image.toJson()).toList();
    await prefs.setString(_imagesKey, json.encode(imagesJson));
  }

  Future<List<WallpaperImage>> loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagesJson = prefs.getString(_imagesKey);

    if (imagesJson != null) {
      try {
        final List<dynamic> jsonList = json.decode(imagesJson);
        return jsonList.map((json) => WallpaperImage.fromJson(json)).toList();
      } catch (e) {
        print('Error loading images: $e');
      }
    }
    return [];
  }

  Future<void> saveStats(AppStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, json.encode(stats.toJson()));
  }

  Future<AppStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);

    if (statsJson != null) {
      try {
        final Map<String, dynamic> statsMap = json.decode(statsJson);
        return AppStats.fromJson(statsMap);
      } catch (e) {
        print('Error loading stats: $e');
      }
    }

    return AppStats(
      totalImages: 0,
      lastWallpaperSet: DateTime.now(),
      totalWallpapersSet: 0,
    );
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_imagesKey);
    await prefs.remove(_statsKey);
  }
}