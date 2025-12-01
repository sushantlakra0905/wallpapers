package com.example.wallpapers

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.wallpaper_picker/wallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaper") {
                val filePath = call.argument<String>("filePath")
                val location = call.argument<Int>("location") ?: 1

                if (filePath == null) {
                    result.success(false)
                    return@setMethodCallHandler
                }

                val file = File(filePath)
                if (!file.exists()) {
                    result.success(false)
                    return@setMethodCallHandler
                }

                try {
                    // Load full-resolution image (NO COMPRESSION)
                    val bitmap = BitmapFactory.decodeFile(filePath)

                    val wallpaperManager = WallpaperManager.getInstance(this)

                    when (location) {
                        1 -> wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                        2 -> wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                        3 -> {
                            wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                            wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                        }
                    }

                    result.success(true)

                } catch (e: Exception) {
                    e.printStackTrace()
                    result.success(false)
                }
            }
        }
    }
}
