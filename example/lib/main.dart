import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_kiosk_android/flutter_kiosk_android.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isDeviceOwner;
  List<String>? _blockedPackages;
  bool? _isInKioskMode;
  bool? _isInstallingApplicationsAllowed;
  final _flutterKioskAndroidPlugin = FlutterKioskAndroid();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _isDeviceOwner = await _flutterKioskAndroidPlugin.isDeviceOwner();
    } on PlatformException {}

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('isDeviceOwner: $_isDeviceOwner\n'),
            ElevatedButton(
              onPressed: () async {
                try {
                  final blocked = await _flutterKioskAndroidPlugin.blockApplications();
                  _blockedPackages = blocked;
                  setState(() {});
                } on PlatformException {}
              },
              child: Text('Block apps'),
            ),
            ElevatedButton(
              onPressed: _blockedPackages != null
                  ? () async {
                      try {
                        await _flutterKioskAndroidPlugin.unblockApplications(packages: _blockedPackages);
                        _blockedPackages = null;
                        setState(() {});
                      } on PlatformException {}
                    }
                  : null,
              child: Text('Unblock apps'),
            ),
            if (_blockedPackages != null)
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _blockedPackages!.length,
                  itemBuilder: (context, index) => Text(_blockedPackages![index]),
                ),
              ),
            ElevatedButton(
              onPressed: _isInKioskMode != true
                  ? () async {
                      try {
                        await _flutterKioskAndroidPlugin.startKioskMode();
                        _isInKioskMode = await _flutterKioskAndroidPlugin.isInKioskMode();
                        setState(() {});
                      } on PlatformException {}
                    }
                  : null,
              child: Text('Start Kiosk'),
            ),
            ElevatedButton(
              onPressed: _isInKioskMode == true
                  ? () async {
                      try {
                        await _flutterKioskAndroidPlugin.stopKioskMode();
                        _isInKioskMode = await _flutterKioskAndroidPlugin.isInKioskMode();
                        setState(() {});
                      } on PlatformException {}
                    }
                  : null,
              child: Text('Stop Kiosk'),
            ),
            Text("KioskMode: ${_isInKioskMode}"),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _flutterKioskAndroidPlugin.allowInstallingApplications();
                  _isInstallingApplicationsAllowed = await _flutterKioskAndroidPlugin.isInstallingApplicationsAllowed();
                  setState(() {});
                } on PlatformException {}
              },
              child: Text( 'Allow installing applications'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _flutterKioskAndroidPlugin.disallowInstallingApplications();
                  _isInstallingApplicationsAllowed = await _flutterKioskAndroidPlugin.isInstallingApplicationsAllowed();
                  setState(() {});
                } on PlatformException {}
              },
              child: Text( 'Disallow installing applications'),
            ),
            Text("isInstallingApplicationsAllowed: ${_isInstallingApplicationsAllowed}"),
          ],
        )),
      ),
    );
  }
}
