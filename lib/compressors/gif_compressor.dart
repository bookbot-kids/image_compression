import 'package:process_run/process_run.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'compressor.dart';

/// Compressor to convert gif image types into png by [Imagemagick](https://imagemagick.org)
class GifCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var outputFile = p.join(outputDir, '${Uuid().v1()}.png');
    await run('magick', ['convert', inputPath, outputFile], verbose: true);
    return outputFile;
  }
}
