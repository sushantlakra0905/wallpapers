import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'controllers/wallpaper_controller.dart';
import 'services/wallpaper_service.dart';

// This function runs in the background (must be TOP LEVEL)
void dailyWallpaperCallback() async {
  final controller = WallpaperController();
  await controller.initialize();

  final randomImage = controller.getRandomImage();
  if (randomImage != null) {
    await WallpaperService.setHomeScreen(randomImage.filePath);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Alarm Manager (DO NOT schedule anything here)
  await AndroidAlarmManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Wallpaper',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const App(),
      debugShowCheckedModeBanner: false,
    );
  }
}
