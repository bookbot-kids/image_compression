import 'package:image_compression/configs.dart';
import 'package:image_compression/file_util.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell_run.dart' as shell;
import 'package:uuid/uuid.dart';
import 'compressor.dart';

/// Compressor that compress png image.by using [pngquant](https://pngquant.org/)
class PngCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var exeFile = p.join(
        await Compressor.processDir, isMacOS ? 'pngquant' : 'pngquant.exe');
    var filename = Uuid().v1();
    var outputFile = p.join(outputDir, '$filename.png');
    await FileUtil.copyFile(inputPath, outputFile);
    await shell.run(
      '$exeFile --ext "-output.png" --quality ${Configs.PngQuality}-${Configs.PngQuality} $outputFile',
      throwOnError: false,
    );

    return p.join(outputDir, '$filename-output.png');
  }
}
