import 'package:image_compression/compressors/compressor.dart';

/// compressor that do nothing
class EmptyCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputPath) async {
    return null;
  }
}
