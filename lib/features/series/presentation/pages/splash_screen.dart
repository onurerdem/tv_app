import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tv_app/features/series/presentation/pages/series_page.dart';

import '../bloc/series_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<SeriesBloc>(context),
          child: const SeriesPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Lottie.asset(
            "assets/animations/tv_animation.json",
          ),
        ),
      ),
    );
  }
}
