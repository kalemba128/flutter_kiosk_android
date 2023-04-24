import 'flutter_kiosk_android_platform_interface.dart';

class FlutterKioskAndroid {
  Future<bool> isDeviceOwner() {
    return FlutterKioskAndroidPlatform.instance.isDeviceOwner();
  }

  Future<List<String>> blockApplications({List<String>? packages}) {
    return FlutterKioskAndroidPlatform.instance.blockApplications(packages: packages);
  }

  Future<List<String>> unblockApplications({List<String>? packages}) {
    return FlutterKioskAndroidPlatform.instance.unblockApplications(packages: packages);
  }

  Future<bool> startKioskMode() {
    return FlutterKioskAndroidPlatform.instance.startKioskMode();
  }

  Future<bool> stopKioskMode() {
    return FlutterKioskAndroidPlatform.instance.stopKioskMode();
  }

  Future<bool> isInKioskMode() {
    return FlutterKioskAndroidPlatform.instance.isInKioskMode();
  }

  Future<bool> disallowInstallingApplications() {
    return FlutterKioskAndroidPlatform.instance.disallowInstallingApplications();
  }

  Future<bool> allowInstallingApplications() {
    return FlutterKioskAndroidPlatform.instance.allowInstallingApplications();
  }

  Future<bool> isInstallingApplicationsAllowed() {
    return FlutterKioskAndroidPlatform.instance.isInstallingApplicationsAllowed();
  }
}
