import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startUp();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startUp();
    }
  }

  Future<void> _startUp() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!context.mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboardingCompleted') ?? false;

    if (!context.mounted) return;

    if (!onboarded) {
      Navigator.of(context).pushReplacementNamed('/onboard');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      print("User: $user");
    }
    print("Kullanıcı durumu (Release Modu): $user");
    if (user == null) {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/signIn');
      return;
    }

    try {
      final idTokenResult = await user.getIdTokenResult();
      if (kDebugMode) {
        print("idTokenResult: $idTokenResult");
      }
      final exp = idTokenResult.expirationTime;

      if (!context.mounted) return;

      if (kDebugMode) {
        print("Exp: $exp");
      }
      if (kDebugMode) {
        print("exp.isBefore(DateTime.now()): ${exp?.isBefore(DateTime.now())}");
      }
      if (kDebugMode) {
        print("DateTime.now(): ${DateTime.now()}");
      }
      if (kDebugMode) {
        print(
            "DateTime.now().add(const Duration(hours: -3)): ${DateTime.now().add(const Duration(hours: -3))}");
      }
      if (kDebugMode) {
        print("user.metadata.lastSignInTime: ${user.metadata.lastSignInTime}");
      }
      if (kDebugMode) {
        print(
            "user.metadata.lastSignInTime?.add(const Duration(hours: 1)): ${user.metadata.lastSignInTime?.add(const Duration(hours: 1))}");
      }
      if (kDebugMode) {
        print(
            "exp?.isBefore(user.metadata.lastSignInTime!.add(const Duration(hours: 1))): ${exp?.isBefore(user.metadata.lastSignInTime!.add(const Duration(hours: 1)))}");
      }
      if (exp == null || exp.isBefore(DateTime.now())) {
        await FirebaseAuth.instance.signOut();

        if (!context.mounted) return;

        Navigator.of(context).pushReplacementNamed('/signIn');
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      print("YAKALANAN HATA (Release Modu): $e");
      print("SplashScreen Hata Yakaladı: $e");
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/signIn');
      return;
    }

    if (!context.mounted) return;

    Navigator.of(context).pushReplacementNamed('/main');

    if (kDebugMode) {
      print("SplashScreen const MainPage(), ********************************");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/animations/tv_animation.json")),
    );
  }
}
