import 'package:image_compression/compressors/compressor.dart';
import 'package:process_run/process_run.dart';

/// Compressor to convert other image types into jpg
class OtherCompressor extends Compressor {
  @override
  Future compress(String inputPath, String outputPath) async {
    return await run(
        'magick', ['convert', inputPath, outputPath + '/output.jpg'],
        verbose: true);
  }
}
