import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';
import 'compressor.dart';

/// Compressor to convert gif image types into png by [Imagemagick](https://imagemagick.org)
/// Output is the list of png files
class GifCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var fileName = newFileName(inputPath);
    var outputFile = p.join(outputDir, '${fileName}.png');
    var exeFile = isMacOS
        ? p.join(await Compressor.processDir, 'magick')
        : p.join(await Compressor.processDir, 'magick.exe');
    await run(exeFile, ['convert', inputPath, outputFile], verbose: true);
    // the output of magick git to png is the list of png files: fileName-01.png, fileName-02.png...
    // so we will get all files that match the file name pattern
    var dir = Directory(outputDir);
    var files = await dir.listSync();
    var result = <String>[];
    files.forEach((element) {
      var path = element.path;
      var name = p.basename(path);
      if (name.contains(fileName)) {
        result.add(path);
      }
    });

    return result;
  }
}
