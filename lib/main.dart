import 'package:flutter/material.dart';

import 'app/bootstrap/app_bootstrap.dart';
import 'app/rmw_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final result = await AppBootstrap().initialize();
  runApp(RmwApp(bootstrapResult: result));
}
