import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amapnaviplugin/amapnaviplugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('amapnaviplugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Amapnaviplugin.platformVersion, '42');
  });
}
