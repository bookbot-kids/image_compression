import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compression/image_compression.dart';
import 'package:universal_io/io.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final testDir = 'working_dir';

  setUp(() async {
    // expose current dir for path_provider on test
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    await ImageCompression.shared.init('');
  });

  tearDown(() {});

  test('test folder', () async {
    var dir = Directory(testDir);

    var files = dir.listSync();
    for (var file in files) {
      if (!File(file.path).existsSync() || file.path.contains('.DS_Store')) {
        continue;
      }

      await ImageCompression.shared.process(
        file.path,
        '',
      );
    }
  });

  test('test gif', () async {
    await ImageCompression.shared.process(
      '$testDir/test.gif',
      null,
    );
  });

  test('test jpg', () async {
    await ImageCompression.shared.process(
      '$testDir/test.jpg',
      '$testDir/test_compressed.jpg',
    );
  });

  test('test svg', () async {
    await ImageCompression.shared.process(
      '$testDir/test.svg',
      '$testDir/test_compressed.svg',
    );

    expect(true, true);
  });

  test('test png', () async {
    await ImageCompression.shared.process(
      '$testDir/test.png',
      '$testDir/test_compressed.png',
    );

    expect(true, true);
  });
}
