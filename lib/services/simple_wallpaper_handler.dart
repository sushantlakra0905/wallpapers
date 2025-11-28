import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class SimpleWallpaperHandler {
  static Future<void> setWallpaper(BuildContext context, String imagePath) async {
    try {
      // Ask permission (Android 10+ requires READ_MEDIA_IMAGES)
      await Permission.storage.request();
      await Permission.photos.request();

      int location = WallpaperManager.HOME_SCREEN;
      // options:
      // HOME_SCREEN
      // LOCK_SCREEN
      // BOTH_SCREEN

      bool result = await WallpaperManager.setWallpaperFromFile(
        imagePath,
        location,
      );

      if (result) {
        _showSuccess(context);
      } else {
        _showError(context, "Failed to set wallpaper.");
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  static void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Wallpaper set successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  static void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
