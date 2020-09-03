import 'package:image_compression/configs.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell_run.dart' as shell;
import 'compressor.dart';

/// Compressor that compress png image.by using [pngquant](https://pngquant.org/)
class PngCompressor extends Compressor {
  @override
  Future compress(String inputPath, String outputDir) async {
    var exeFile = p.join(
        await Compressor.processDir, isMacOS ? 'pngquant' : 'pngquant.exe');
    try {
      return await shell.Shell().run(
          '$exeFile --ext "-output.png" --quality ${Configs.PngQuality}-${Configs.PngQuality} $inputPath');
    } catch (e) {
      print(e);
    }
  }
}
