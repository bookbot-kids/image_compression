import 'package:process_run/process_run.dart';

import 'compressor.dart';
import 'package:path/path.dart' as p;

class SvgCompressor extends Compressor {
  @override
  Future compress(String inputPath, String outputDir) async {
    var exeFile = p.join(await Compressor.processDir,
        isMacOS ? 'svgcleaner-cli' : 'svgcleaner_win32_0.9.5.exe');
    return await run(exeFile, [inputPath, outputDir + '/output.svg'],
        verbose: true);
  }
}
