import 'package:image_compression/image_compression.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell_run.dart' as shell;
import 'compressor.dart';

/// Compressor that compress png image.by using [pngquant](https://pngquant.org/) and [zopfli](https://github.com/google/zopfli)
///
/// On windows, the binary is downloaded from [zopflipng-bin](https://github.com/imagemin/zopflipng-bin)
class PngCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var pngquantExeFile = p.join(
        await Compressor.processDir, isMacOS ? 'pngquant' : 'pngquant.exe');
    var filename = newFileName(inputPath);
    // copy input to a new file because pngquant working on this file directly
    var pngquantInputFile = p.join(outputDir, '$filename.png');
    await FileUtil.copyFile(inputPath, pngquantInputFile);
    final pngquantSuffix = '_output.png';

    var pngquantOutputFile = p.join(outputDir, '${filename}${pngquantSuffix}');
    var zopfliExeFile = p.join(
        await Compressor.processDir, isMacOS ? 'zopflipng' : 'zopflipng.exe');

    // final output
    var output = p.join(outputDir, '${filename}_compressed.png');
    await shell.run(
      '''
      # run pngquant
      "$pngquantExeFile" --ext "$pngquantSuffix" --quality ${ImageCompression.shared.pngQuality}-${ImageCompression.shared.pngQuality} "$pngquantInputFile"
      # then run zopfli
      "$zopfliExeFile" "$pngquantOutputFile" "$output"

      ''',
      throwOnError: false,
    );

    // delete temp files
    await FileUtil.delete(pngquantInputFile);
    await FileUtil.delete(pngquantOutputFile);
    return output;
  }
}
