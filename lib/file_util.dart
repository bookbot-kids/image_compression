import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:image_compression/configs.dart';
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;

class FileUtil {
  /// Resize image if the image size > maxSize. Only resize JPEG, PNG image
  /// Return original path if size <= maxSize, otherwise return new path
  static Future<String> resizeIfNeeded(
    String inputDir,
    String imageFile,
  ) async {
    var fileExtension = p.extension(imageFile).toLowerCase();
    if (!['jpg', 'png', 'jpeg'].contains(fileExtension)) {
      return imageFile;
    }

    var isPng = fileExtension == 'png';
    var file = File(imageFile);
    var fileName = p.basenameWithoutExtension(imageFile);
    var bytes = file.readAsBytesSync();
    var decodedImage = await decodeImageFromList(bytes);
    print('image size ${decodedImage.width}, ${decodedImage.height}');
    if (decodedImage.width > Configs.MaxSize ||
        decodedImage.height > Configs.MaxSize) {
      final widthRatio = Configs.MaxSize / decodedImage.width;
      final heightRatio = Configs.MaxSize / decodedImage.height;
      final ratio = min(widthRatio, heightRatio);
      var originImage = img.decodeImage(bytes);
      final resizedPath =
          p.join(inputDir, '${fileName}_resized${fileExtension}');
      final targetWidth = (decodedImage.width * ratio).toInt();
      final targetHeight = (decodedImage.height * ratio).toInt();
      print('resize to $targetWidth, $targetHeight at path $resizedPath');
      final resizedImage =
          img.copyResize(originImage, width: targetWidth, height: targetHeight);
      File(resizedPath)
        ..writeAsBytesSync(
            isPng ? img.encodePng(resizedImage) : img.encodeJpg(resizedImage));
      return resizedPath;
    }

    return imageFile;
  }

  /// Copy file, ignore if exist
  static Future<void> copyFile(String from, String to) async {
    if (await File(to).exists()) {
      return;
    }

    var file = File(from);
    await file.copy(to);
  }
}
