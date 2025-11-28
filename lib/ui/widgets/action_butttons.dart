//action_buttons.dart
import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAddMultipleImages; // This will handle all adding
  final VoidCallback onRandomWallpaper;
  final bool isLoading;

  const ActionButtons({
    super.key,
    required this.onAddMultipleImages,
    required this.onRandomWallpaper,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Single button: Add Photos
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddMultipleImages,
              icon: const Icon(Icons.collections),
              label: const Text('Add Photos'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Random wallpaper button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onRandomWallpaper,
              icon: isLoading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Icon(Icons.shuffle),
              label: Text(isLoading ? 'Loading...' : 'Random Wallpaper'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
