export 'gif_compressor.dart';
export 'jpg_compressor.dart';
export 'png_compressor.dart';
export 'svg_compressor.dart';
export 'other_compressor.dart';
export 'empty_compressor.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';

/// The base image compressor
abstract class Compressor {
  Future<dynamic> compress(String inputPath, String outputPath);

  /// Get working directory
  static Future<String> get processDir async {
    var tempDir = await getTemporaryDirectory();
    final dir = Directory(p.join(tempDir.path, 'image_compression'));
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  bool get isMacOS => UniversalPlatform.isMacOS;
}
