import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_compression/image_compression.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final testDir = '/working_dir';

  setUp(() async {
    // expose current dir for path_provider on test
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });

    await ImageCompression.shared.config();
  });

  tearDown(() {});

  test('test jpg', () async {
    await ImageCompression.shared.process(
      testDir,
      'test.jpg',
      '$testDir/output',
    );
  });

  test('test svg', () async {
    await ImageCompression.shared.process(
      testDir,
      'test.svg',
      '$testDir/output',
    );

    expect(true, true);
  });

  test('test png', () async {
    await ImageCompression.shared.process(
      testDir,
      'test.png',
      '$testDir/output',
    );

    expect(true, true);
  });
}
