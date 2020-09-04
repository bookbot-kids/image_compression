import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;
import 'compressor.dart';

class JpgCompressor extends Compressor {
  @override
  Future compress(String inputPath, String outputDir) async {
    var exeFile = p.join(
        await Compressor.processDir, isMacOS ? 'jpegoptim' : 'jpegoptim.exe');
    return await run(exeFile, ['-m 40', inputPath], verbose: true);
  }
}
