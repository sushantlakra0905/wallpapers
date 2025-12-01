//image_service.dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // Keep original quality
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Image picker error: $e');
      throw Exception('Failed to pick image. Please grant photo access in app settings.');
    }
  }

  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        // Keep original quality
      );

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      print('Multiple image picker error: $e');
      throw Exception('Failed to pick images. Please grant photo access in app settings.');
    }
  }

  Future<int> getFileSize(File file) async {
    try {
      final stat = await file.stat();
      return stat.size;
    } catch (e) {
      return 0;
    }
  }

  String getFileName(String path) {
    return path.split('/').last;
  }
}
