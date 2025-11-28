import 'package:flutter/material.dart';
import '../../models/wallpaper_model.dart';

class StatsCard extends StatelessWidget {
  final AppStats stats;

  const StatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              value: stats.totalImages.toString(),
              label: 'Total Images',
              icon: Icons.photo_library,
              color: Colors.blue,
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            _buildStatItem(
              value: stats.totalWallpapersSet.toString(),
              label: 'Wallpapers Set',
              icon: Icons.wallpaper,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}