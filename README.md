# flutter_kiosk_android

## Installation

1. Create file **device_admin.xml** in android/app/ ... /res/xml/device_admin.xml with following content:
   ```
   <device-admin xmlns:android="http://schemas.android.com/apk/res/android">
   </device-admin>
   ```
2. Add required permissions and receiver to **AndroidManifest.xml**
   ```
   <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
   ```

    ```
   <application
        
        ...
   
        <receiver
                android:name="com.kalemba128.flutter_kiosk_android.FlutterKioskAndroidPlugin"
                android:exported="true"
                android:permission="android.permission.BIND_DEVICE_ADMIN">
            <meta-data
                    android:name="android.app.device_admin"
                    android:resource="@xml/device_admin"/>
            <intent-filter>
                <action android:name="android.app.action.DEVICE_ADMIN_ENABLED"/>
            </intent-filter>
        </receiver>
   
        ...

    </application>
   ```

## Make app device owner

   ```
   adb shell dpm set-device-owner com.example.app/com.kalemba128.flutter_kiosk_android.FlutterKioskAndroidPlugin
   ```
