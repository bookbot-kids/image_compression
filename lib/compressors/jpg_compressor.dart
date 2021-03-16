import 'package:image_compression/file_util.dart';
import 'package:image_compression/image_compression.dart';
import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;
import 'compressor.dart';

/// Compressor to compress jpg by [jpegoptim](https://github.com/tjko/jpegoptim)
class JpgCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var exeFile = p.join(
        await Compressor.processDir, isMacOS ? 'jpegoptim' : 'jpegoptim.exe');
    var outputFile = p.join(outputDir, '${newFileName(inputPath)}.jpg');
    await FileUtil.copyFile(inputPath, outputFile);
    await runExecutableArguments(
        exeFile, ['-m ${ImageCompression.shared.jpgQuality}', outputFile],
        verbose: true);
    return outputFile;
  }
}
