import 'package:flutter/material.dart';
import 'package:wallpaper_picker/app/splash_screen.dart';
import 'package:wallpaper_picker/ui/home_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash ? const SplashScreen() : const HomeScreen();
  }
}