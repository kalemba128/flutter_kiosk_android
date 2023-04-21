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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
