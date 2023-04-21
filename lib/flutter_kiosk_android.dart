
import 'flutter_kiosk_android_platform_interface.dart';

class FlutterKioskAndroid {
  Future<String?> getPlatformVersion() {
    return FlutterKioskAndroidPlatform.instance.getPlatformVersion();
  }
}
