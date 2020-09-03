import 'package:flutter_test/flutter_test.dart';
import 'package:image_compression/image_compression.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  test('process', () async {
    await ImageCompression.shared.process(
      'working_dir',
      '1.jpg',
      'working_dir/output',
    );
    expect(await ImageCompression.shared.platformVersion, '42');
  });
}
