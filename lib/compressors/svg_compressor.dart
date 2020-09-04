import 'package:image_compression/file_util.dart';
import 'package:uuid/uuid.dart';
import 'package:process_run/shell_run.dart' as shell;
import 'compressor.dart';
import 'package:path/path.dart' as p;

/// Compressor that compress svg image.by using [svgcleaner](https://github.com/RazrFalcon/svgcleaner)
/// and [svgo](https://github.com/svg/svgo) (the binary is built from [svgop](https://github.com/twardoch/svgop))
class SvgCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var svgCleanerExeFile = p.join(await Compressor.processDir,
        isMacOS ? 'svgcleaner-cli' : 'svgcleaner_win32_0.9.5.exe');
    var filename = Uuid().v1();
    var svgCleanerOutput = p.join(outputDir, '$filename.svg');

    var svgGoExeFile =
        p.join(await Compressor.processDir, isMacOS ? 'svgop' : 'svgop.exe');
    var svgGoOutput = p.join(outputDir, '$filename.min.svg');
    await shell.run('''
        # run svg cleaner
        $svgCleanerExeFile $inputPath $svgCleanerOutput
        # then run svggo from svg cleaner output
        $svgGoExeFile < $svgCleanerOutput > $svgGoOutput
      ''', throwOnError: false);

    // delete svg cleaner temp result
    await FileUtil.delete(svgCleanerOutput);
    return svgGoOutput;
  }
}
