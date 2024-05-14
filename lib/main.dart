import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/tv_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const TvApp());
}