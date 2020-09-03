export 'gif_compressor.dart';
export 'jpg_compressor.dart';
export 'png_compressor.dart';
export 'svg_compressor.dart';
export 'other_compressor.dart';
export 'empty_compressor.dart';

/// The base image compressor
abstract class Compressor {
  Future<dynamic> compress(String inputPath, String outputPath);
}
