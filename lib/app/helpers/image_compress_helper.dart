import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCompressHelper {
  static Future<File?> compressToHardLimit({
  required File file,
  int maxSizeInKB = 100,
  bool debugMode = true,
}) async {
  try {
    final originalSizeKB = file.lengthSync() / 1024;

    if (originalSizeKB <= maxSizeInKB) return file;

    final dir = await getTemporaryDirectory();
    File? compressedFile;

    int quality = 85;

    while (quality >= 40) {
      final targetPath = p.join(
        dir.path,
        "${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;

      compressedFile = File(result.path);
      final sizeKB = compressedFile.lengthSync() / 1024;

      if (debugMode) {
        debugPrint("SOFT → Quality: $quality | Size: ${sizeKB.toStringAsFixed(2)} KB");
      }

      if (sizeKB <= maxSizeInKB) return compressedFile;

      quality -= 10;
    }

    int width = 800;

    while (width >= 300) {
      final targetPath = p.join(
        dir.path,
        "${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 10,
        minWidth: width,
        minHeight: width,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;

      compressedFile = File(result.path);
      final sizeKB = compressedFile.lengthSync() / 1024;

      if (debugMode) {
        debugPrint("BRUTAL → Width: $width | Size: ${sizeKB.toStringAsFixed(2)} KB");
      }

      if (sizeKB <= maxSizeInKB) return compressedFile;

      width -= 100;
    }

    return compressedFile;

  } catch (e) {
    debugPrint("Compress Error: $e");
    return null;
  }
}
}