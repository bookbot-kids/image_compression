import 'dart:async';

import 'package:image_compression/compressors/compressor.dart';
import 'package:image_compression/image_types.dart';
import 'package:image_compression/file_util.dart';
import 'package:path/path.dart' as p;
import 'package:universal_platform/universal_platform.dart';

/// Image compression tool.
/// If image larger than [Configs.MaxSize], then it's resized before compressioning
///
/// If GIF convert to PNG with [Imagemagick](https://imagemagick.org)
///
/// If not SVG, PNG or JPG convert to JPG with [Imagemagick](https://imagemagick.org). Ignore EPS or AI files
///
/// If SVG use [svgcleaner](https://github.com/RazrFalcon/svgcleaner) and [svgo](https://github.com/svg/svgo)
///
/// If PNG use [pngquant](https://pngquant.org) and [zopfli](https://github.com/google/zopfli) Quality 40%
///
/// If JPG use [jpegoptim](https://github.com/tjko/jpegoptim) Qualiy 50%
class ImageCompression {
  ImageCompression._privateConstructore();
  static ImageCompression shared = ImageCompression._privateConstructore();

  /// The Compressor map. Each file type has its own compressor
  final Map<ImageType, Compressor> _compressors = {
    ImageType.gif: GifCompressor(),
    ImageType.jpg: JpgCompressor(),
    ImageType.svg: SvgCompressor(),
    ImageType.png: PngCompressor(),
    ImageType.ai: EmptyCompressor(),
    ImageType.eps: EmptyCompressor(),
  };

  Future<void> config() async {
    if (UniversalPlatform.isMacOS) {
      // install imagemagick
      //await run('brew', ['install', 'imagemagick'], verbose: true);

      // copy binary files into executeable dir
      final binaries = [
        'svgcleaner-cli',
        'pngquant',
        'jpegoptim',
        'svgop',
        'zopflipng',
      ];
      for (var binary in binaries) {
        await FileUtil.copyFile(
            'binaries/$binary', p.join(await Compressor.processDir, binary));
      }
    } else if (UniversalPlatform.isWindows) {
      // copy execute into current dir

      // copy binary files into executeable dir
      final binaries = [
        'svgcleaner_win32_0.9.5.exe',
        'pngquant.exe',
        'svgop.exe'
      ];
      for (var binary in binaries) {
        await FileUtil.copyFile(
            'binaries/$binary', p.join(await Compressor.processDir, binary));
      }
    }
  }

  /// compress an image and return the output file
  Future<dynamic> process(
      String inputDir, String fileName, String outputDir) async {
    var file = p.join(inputDir, fileName);
    var fileExtension = p.extension(file).toLowerCase();
    var inputFile = await FileUtil.resizeIfNeeded(inputDir, file);
    var compressor =
        _compressors[$ImageType.fromString(fileExtension)] ?? OtherCompressor();
    var output = await compressor?.compress(inputFile, outputDir);
    print('process [$inputFile] with [$compressor] has output: [$output]');
    return output;
  }
}
