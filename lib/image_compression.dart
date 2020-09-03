import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_compression/compressors/compressor.dart';
import 'package:image_compression/image_types.dart';
import 'package:image_compression/image_util.dart';
import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;
import 'package:universal_platform/universal_platform.dart';

class ImageCompression {
  ImageCompression._privateConstructore();
  static ImageCompression shared = ImageCompression._privateConstructore();
  static const MethodChannel _channel = MethodChannel('image_compression');

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
      await run('brew', ['install', 'imagemagick'], verbose: true);
    } else if (UniversalPlatform.isWindows) {
      // copy execute into current dir
    }
  }

  Future<String> get platformVersion async {
    final version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<dynamic> process(
      String inputDir, String fileName, String outputDir) async {
    var file = p.join(inputDir, fileName);
    var fileExtension = p.extension(file).toLowerCase();
    var inputFile = await ImageUtil.resizeIfNeeded(inputDir, file);
    var compressor =
        _compressors[$ImageType.fromString(fileExtension)] ?? OtherCompressor();
    print('process [$inputFile] with [$compressor]');
    return await compressor?.compress(inputFile, outputDir);
  }
}
