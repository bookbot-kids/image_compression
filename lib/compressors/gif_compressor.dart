import 'package:process_run/process_run.dart';

import 'compressor.dart';

/// Compressor to convert gif image types into png
class GifCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputPath) async {
    return await run('magick', ['convert', inputPath, outputPath + '/output.png'],
        verbose: true);
  }
}
