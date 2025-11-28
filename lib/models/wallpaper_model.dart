// lib/models/wallpaper_model.dart

class WallpaperImage {
  final String id;
  final String filePath;
  final String fileName;
  final DateTime addedDate;
  final int fileSize;

  WallpaperImage({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.addedDate,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'addedDate': addedDate.toIso8601String(),
      'fileSize': fileSize,
    };
  }

  factory WallpaperImage.fromJson(Map<String, dynamic> json) {
    return WallpaperImage(
      id: json['id'],
      filePath: json['filePath'],
      fileName: json['fileName'],
      addedDate: DateTime.parse(json['addedDate']),
      fileSize: json['fileSize'],
    );
  }
}

class AppStats {
  final int totalImages;
  final DateTime lastWallpaperSet;
  final int totalWallpapersSet;

  AppStats({
    required this.totalImages,
    required this.lastWallpaperSet,
    required this.totalWallpapersSet,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalImages': totalImages,
      'lastWallpaperSet': lastWallpaperSet.toIso8601String(),
      'totalWallpapersSet': totalWallpapersSet,
    };
  }

  factory AppStats.fromJson(Map<String, dynamic> json) {
    return AppStats(
      totalImages: json['totalImages'],
      lastWallpaperSet: DateTime.parse(json['lastWallpaperSet']),
      totalWallpapersSet: json['totalWallpapersSet'],
    );
  }
}
