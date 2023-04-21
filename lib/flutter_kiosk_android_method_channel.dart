import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_kiosk_android_platform_interface.dart';

/// An implementation of [FlutterKioskAndroidPlatform] that uses method channels.
class MethodChannelFlutterKioskAndroid extends FlutterKioskAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_kiosk_android');

  @override
  Future<bool> isDeviceOwner() async {
    final version = await methodChannel.invokeMethod<bool>('isDeviceOwner');
    return version!;
  }

  @override
  Future<List<String>> blockApplications({List<String>? packages}) async {
    final version = await methodChannel.invokeMethod<List<dynamic>>('blockApplications', {'packages': packages});
    return version?.cast<String>() ?? [];
  }

  @override
  Future<List<String>> unblockApplications({List<String>? packages}) async {
    final version = await methodChannel.invokeMethod<List<dynamic>>('unblockApplications', {'packages': packages});
    return version?.cast<String>() ?? [];
  }

  @override
  Future<bool> startKioskMode() async {
    final version = await methodChannel.invokeMethod<bool>('startKioskMode');
    return version!;
  }

  @override
  Future<bool> stopKioskMode() async {
    final version = await methodChannel.invokeMethod<bool>('stopKioskMode');
    return version!;
  }

  @override
  Future<bool> isInKioskMode() async {
    final version = await methodChannel.invokeMethod<bool>('isInKioskMode');
    return version!;
  }
}
