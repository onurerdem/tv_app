import 'package:flutter/material.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_scaffold_widget.dart';
import 'package:tv_app/core/navigation/services/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      isInit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<AppNavigationService>().routeToTvShows();
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const UIMainScaffold(
      canPop: false,
      body: Center(
        child: UILoadingIndicator(),
      ),
    );
  }
}