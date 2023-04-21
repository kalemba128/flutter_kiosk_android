import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_kiosk_android_method_channel.dart';

abstract class FlutterKioskAndroidPlatform extends PlatformInterface {
  /// Constructs a FlutterKioskAndroidPlatform.
  FlutterKioskAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterKioskAndroidPlatform _instance = MethodChannelFlutterKioskAndroid();

  /// The default instance of [FlutterKioskAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterKioskAndroid].
  static FlutterKioskAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterKioskAndroidPlatform] when
  /// they register themselves.
  static set instance(FlutterKioskAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isDeviceOwner() {
    throw UnimplementedError('isDeviceOwner() has not been implemented.');
  }

  Future<List<String>> blockApplications({List<String>? packages}) {
    throw UnimplementedError('blockApplications() has not been implemented.');
  }

  Future<List<String>> unblockApplications({List<String>? packages}) {
    throw UnimplementedError('unblockApplications() has not been implemented.');
  }

  Future<bool> startKioskMode() {
    throw UnimplementedError('startKioskMode() has not been implemented.');
  }

  Future<bool> stopKioskMode() {
    throw UnimplementedError('stopKioskMode() has not been implemented.');
  }

  Future<bool> isInKioskMode() {
    throw UnimplementedError('isInKioskMode() has not been implemented.');
  }
}
