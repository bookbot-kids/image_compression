import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_compression/configs.dart';
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;

class FileUtil {
  /// Resize image if the image size > maxSize. Only resize JPEG, PNG image
  /// Return copied file if size <= maxSize, otherwise return new path
  static Future<String> copyOrResize(
    String inputFile,
    String outputFile,
  ) async {
    var fileExtension = p.extension(inputFile).toLowerCase();
    if (!['.jpg', '.png', '.jpeg'].contains(fileExtension)) {
      await copyFile(inputFile, outputFile);
      return outputFile;
    }

    var isPng = fileExtension == '.png';
    var file = File(inputFile);
    var bytes = file.readAsBytesSync();
    var decodedImage = await decodeImageFromList(bytes);
    print('image size ${decodedImage.width}, ${decodedImage.height}');
    if (decodedImage.width > Configs.MaxSize ||
        decodedImage.height > Configs.MaxSize) {
      final widthRatio = Configs.MaxSize / decodedImage.width;
      final heightRatio = Configs.MaxSize / decodedImage.height;
      final ratio = min(widthRatio, heightRatio);
      var originImage = img.decodeImage(bytes);
      final targetWidth = (decodedImage.width * ratio).toInt();
      final targetHeight = (decodedImage.height * ratio).toInt();
      print('resize to $targetWidth, $targetHeight at path $outputFile');
      final resizedImage =
          img.copyResize(originImage, width: targetWidth, height: targetHeight);
      File(outputFile)
        ..writeAsBytesSync(
            isPng ? img.encodePng(resizedImage) : img.encodeJpg(resizedImage));
      return outputFile;
    }

    await copyFile(inputFile, outputFile);
    return outputFile;
  }

  /// Copy file, ignore if exist
  static Future<void> copyFile(String from, String to) async {
    if (await File(to).exists()) {
      return;
    }

    var file = File(from);
    await file.copy(to);
  }

  /// Copy file from asset, ignore if exist
  static Future<void> copyAssetFile(String asssetPath, String to) async {
    var destFile = File(to);
    if (await destFile.exists()) {
      return;
    }

    final data = await rootBundle.load(asssetPath);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await destFile.writeAsBytes(bytes);
  }

  /// Delete a file
  static Future<void> delete(String path) async {
    if (await File(path).exists()) {
      await File(path).delete();
    }
  }
}
