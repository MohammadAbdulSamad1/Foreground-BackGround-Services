import 'dart:async';
import 'dart:developer';

import 'package:background_services/check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.location.isDenied.then((value) {
    if (value) {
      Permission.location.request();
    }
  });
  Permission.sms.isDenied.then((value) {
    if (value) {
      Permission.sms.request();
    }
  });
  Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await initializeService();

  runApp(const background());
}

Future<void> initializeService() async {
  final Service = FlutterBackgroundService();
  await Service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration:
          AndroidConfiguration(onStart: onStart, isForegroundMode: true));

  await Service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "foreground service",
            content: "Update at ${DateTime.now()}");
      }
    }
  });
}
