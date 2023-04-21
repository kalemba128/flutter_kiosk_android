import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kiosk_android/flutter_kiosk_android.dart';
import 'package:flutter_kiosk_android/flutter_kiosk_android_platform_interface.dart';
import 'package:flutter_kiosk_android/flutter_kiosk_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterKioskAndroidPlatform
    with MockPlatformInterfaceMixin
    implements FlutterKioskAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterKioskAndroidPlatform initialPlatform = FlutterKioskAndroidPlatform.instance;

  test('$MethodChannelFlutterKioskAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterKioskAndroid>());
  });

  test('getPlatformVersion', () async {
    FlutterKioskAndroid flutterKioskAndroidPlugin = FlutterKioskAndroid();
    MockFlutterKioskAndroidPlatform fakePlatform = MockFlutterKioskAndroidPlatform();
    FlutterKioskAndroidPlatform.instance = fakePlatform;

    expect(await flutterKioskAndroidPlugin.getPlatformVersion(), '42');
  });
}
