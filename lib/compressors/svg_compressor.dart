import 'package:process_run/shell_run.dart' as shell;
import 'compressor.dart';
import 'package:path/path.dart' as p;

/// Compressor that compress svg image.by using [svgcleaner](https://github.com/RazrFalcon/svgcleaner)
/// and [svgo](https://github.com/svg/svgo) (the binary is built from [svgop](https://github.com/twardoch/svgop))
class SvgCompressor extends Compressor {
  @override
  Future<dynamic> compress(String inputPath, String outputDir) async {
    var svgCleanerExeFile = p.join(await Compressor.processDir,
        isMacOS ? 'svgcleaner-cli' : 'svgcleaner-cli.exe');
    var filename = newFileName(inputPath);
    var svgCleanerOutput = p.join(outputDir, '$filename.svg');
    await shell.run('''
        # run svg cleaner
        "$svgCleanerExeFile" "$inputPath" "$svgCleanerOutput"
      ''', throwOnError: false);

    return svgCleanerOutput;
  }
}
