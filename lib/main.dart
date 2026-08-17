import 'package:flutter/material.dart';

import 'app/bootstrap/app_bootstrap.dart';
import 'app/rmw_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    final message = details.exceptionAsString();
    return Material(
      color: const Color(0xFF18070F),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RMW DIAGNOSE',
                  style: TextStyle(
                    color: Color(0xFFFF2E9A),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Flutter hat beim Aufbau dieser Seite einen Fehler gemeldet:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  final result = await AppBootstrap().initialize();
  runApp(RmwApp(bootstrapResult: result));
}
