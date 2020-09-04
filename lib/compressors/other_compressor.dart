import 'package:image_compression/compressors/compressor.dart';
import 'package:process_run/process_run.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

/// Compressor to convert other image types into jpg
class OtherCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputPath) async {
    var outputFile = p.join(outputPath, '${Uuid().v1()}.jpg');
    await run('magick', ['convert', inputPath, outputFile], verbose: true);
    return outputFile;
  }
}
