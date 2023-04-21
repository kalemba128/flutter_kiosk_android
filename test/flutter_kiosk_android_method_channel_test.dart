import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kiosk_android/flutter_kiosk_android_method_channel.dart';

void main() {
  MethodChannelFlutterKioskAndroid platform = MethodChannelFlutterKioskAndroid();
  const MethodChannel channel = MethodChannel('flutter_kiosk_android');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
