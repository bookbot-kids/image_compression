import 'package:image_compression/configs.dart';
import 'package:image_compression/file_util.dart';
import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'compressor.dart';

/// Compressor to compress jpg by [jpegoptim](https://github.com/tjko/jpegoptim)
class JpgCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var exeFile = p.join(
        await Compressor.processDir, isMacOS ? 'jpegoptim' : 'jpegoptim.exe');
    var outputFile = p.join(outputDir, '${Uuid().v1()}.jpg');
    await FileUtil.copyFile(inputPath, outputFile);
    await run(exeFile, ['-m ${Configs.JpgQuality}', outputFile], verbose: true);
    return outputFile;
  }
}
