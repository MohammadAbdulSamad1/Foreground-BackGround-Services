import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class background extends StatefulWidget {
  const background({super.key});

  @override
  State<background> createState() => _backgroundState();
}

String text = "Stop Service";

class _backgroundState extends State<background> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("setAsForeground");
              },
              child: Text("ForeGround Mode")),
          ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("setAsBackground");
              },
              child: Text("Background Mode")),
          ElevatedButton(
              onPressed: () async {
                final Service = FlutterBackgroundService();
                var isRunning = await Service.isRunning();
                if (isRunning) {
                  Service.invoke("stopService");
                } else {
                  Service.startService();
                }

                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = "Start Service";
                }
                setState(() {});
              },
              child: Text(text)),
        ],
      ),
    );
  }
}
