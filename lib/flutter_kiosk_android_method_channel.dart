import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_kiosk_android_platform_interface.dart';

/// An implementation of [FlutterKioskAndroidPlatform] that uses method channels.
class MethodChannelFlutterKioskAndroid extends FlutterKioskAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_kiosk_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
