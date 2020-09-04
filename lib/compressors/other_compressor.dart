import 'package:image_compression/compressors/compressor.dart';
import 'package:process_run/process_run.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

/// Compressor to convert other image types into jpg by [Imagemagick](https://imagemagick.org)
class OtherCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputPath) async {
    var outputFile = p.join(outputPath, '${Uuid().v1()}.jpg');
    var exeFile = isMacOS
        ? 'magick' // from homebrew
        : p.join(await Compressor.processDir, 'magick.exe');
    await run(exeFile, ['convert', inputPath, outputFile], verbose: true);
    return outputFile;
  }
}
