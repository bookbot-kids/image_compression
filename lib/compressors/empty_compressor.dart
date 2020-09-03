import 'package:image_compression/compressors/compressor.dart';

/// compressor that do nothing
class EmptyCompressor extends Compressor {
  @override
  Future compress(String inputPath, String outputPath) {
    return null;
  }
}
