import 'package:flutter/services.dart';

class WallpaperService {
  static const platform = MethodChannel('com.example.wallpaper_picker/wallpaper');

  static Future<bool> setWallpaper(String filePath, WallpaperLocation location) async {
    try {
      final int locationValue = location.index + 1; // Convert enum to int

      final bool result = await platform.invokeMethod('setWallpaper', {
        'filePath': filePath,
        'location': locationValue,
      });

      return result;
    } on PlatformException catch (e) {
      print("Failed to set wallpaper: '${e.message}'.");
      return false;
    } catch (e) {
      print("Unexpected error: $e");
      return false;
    }
  }

  static Future<bool> setHomeScreen(String filePath) async {
    return await setWallpaper(filePath, WallpaperLocation.HOME);
  }

  static Future<bool> setLockScreen(String filePath) async {
    return await setWallpaper(filePath, WallpaperLocation.LOCK);
  }

  static Future<bool> setBoth(String filePath) async {
    return await setWallpaper(filePath, WallpaperLocation.BOTH);
  }
}

enum WallpaperLocation {
  HOME,
  LOCK,
  BOTH,
}