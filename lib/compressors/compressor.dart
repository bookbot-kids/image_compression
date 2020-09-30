export 'gif_compressor.dart';
export 'jpg_compressor.dart';
export 'png_compressor.dart';
export 'svg_compressor.dart';
export 'other_compressor.dart';
export 'empty_compressor.dart';
import 'package:image_compression/image_compression.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';

/// The base image compressor
abstract class Compressor {
  Future<dynamic> compress(String inputPath, String outputPath);

  /// Get working directory
  static Future<String> get processDir async {
    final dir = Directory(
        p.join(ImageCompression.shared.workingDir, 'image_compression'));
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  bool get isMacOS => UniversalPlatform.isMacOS;

  /// Create new file name from current file path
  String newFileName(String inputPath) {
    var filename = p.basenameWithoutExtension(inputPath);
    var now = DateTime.now();
    return '${filename}_${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  }
}
