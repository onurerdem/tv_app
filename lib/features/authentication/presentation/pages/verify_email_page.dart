import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/authentication/presentation/widgets/snack_bar_error.dart';
import '../../../../main.dart';
import '../cubit/user/user_cubit.dart';
import '../widgets/snack_bar.dart';

class VerifyEmailPage extends StatelessWidget {
  VerifyEmailPage({super.key});

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Timer? expiryTimer;

    Future<void> startUp() async {
      expiryTimer?.cancel();

      final user = FirebaseAuth.instance.currentUser;
      if (kDebugMode) {
        print("User: $user");
      }
      if (user == null) {
        return;
      }

      try {
        final idTokenResult = await user.getIdTokenResult();
        if (kDebugMode) {
          print("idTokenResult: $idTokenResult");
        }
        final exp = idTokenResult.expirationTime;
        if (kDebugMode) {
          print("Exp: $exp");
        }
        if (kDebugMode) {
          print(
              "exp.isBefore(DateTime.now()): ${exp?.isBefore(DateTime.now())}");
        }
        if (kDebugMode) {
          print("DateTime.now(): ${DateTime.now()}");
        }
        if (kDebugMode) {
          print(
              "DateTime.now().add(const Duration(hours: -3)): ${DateTime.now().add(const Duration(hours: -3))}");
        }
        if (kDebugMode) {
          print(
              "user.metadata.lastSignInTime: ${user.metadata.lastSignInTime}");
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
          Navigator.of(context).pushReplacementNamed('/signIn');
          return;
        }

        final now = DateTime.now();
        if (kDebugMode) {
          print("NOW: $now");
        }
        final duration = exp.difference(now);
        if (kDebugMode) {
          print("DURATION: $duration");
        }
        if (kDebugMode) {
          print("duration.isNegative: ${duration.isNegative}");
        }
        if (duration.isNegative) {
          if (kDebugMode) {
            print("duration.isNegative2: ${duration.isNegative}");
          }
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacementNamed('/signIn');
          return;
        }
        expiryTimer = Timer(duration, () {
          if (kDebugMode) {
            print("TIMER: $duration");
          }
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacementNamed('/signIn');
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed('/signIn');
        return;
      }
    }

    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (prev, curr) =>
          curr is UserIsNull ||
          curr is UserVerificationFailed ||
          curr is ResendEmailVerificationSuccess ||
          curr is ResendEmailVerificationFailure ||
          curr is TooManyRequests ||
          curr is UserSuccess,
      listener: (context, state) {
        if (state is UserIsNull) {
          snackBarError(
            msg: 'User not found, please log in again.',
            scaffoldState: _globalKey,
          );

          if (kDebugMode) {
            print(
                "User not found, please log in again. **********************************************************");
          }

          Navigator.of(context)
              .pushNamedAndRemoveUntil('/signIn', (_) => false);
        } else if (state is UserVerificationFailed) {
          snackBarError(
            msg: 'Email could not be verified, please try again later.',
            scaffoldState: _globalKey,
          );

          if (kDebugMode) {
            print(
                "Email could not be verified, please try again later. **********************************************************");
          }
        } else if (state is ResendEmailVerificationSuccess) {
          snackBar(
            msg: 'Verification email resent.',
            scaffoldState: _globalKey,
          );

          if (kDebugMode) {
            print(
                "Verification email resent. **********************************************************");
          }
        } else if (state is ResendEmailVerificationFailure) {
          snackBarError(
            msg:
                'The verification email could not be resent,\nplease try again later.',
            scaffoldState: _globalKey,
          );

          if (kDebugMode) {
            print(
                "The verification email could not be resent, please try again later. **********************************************************");
          }
        } else if (state is TooManyRequests) {
          snackBarError(
            msg: 'Too many requests, please try again later.',
            scaffoldState: _globalKey,
          );

          if (kDebugMode) {
            print(
                "Too many requests, please try again later. **********************************************************");
          }
        } else if (state is UserSuccess) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil('/main', (route) => false);

          if (kDebugMode) {
            print(
                "VerifyEmailPage const MainPage(), **********************************************************");
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is UserLoading;
        return Scaffold(
          key: _globalKey,
          appBar: AppBar(
            title: const Text('Email Verification'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_read,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'A verification email has been sent.\nPlease check your inbox and\nclick the “I approved it." button.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<UserCubit>().checkEmailVerified();
                            startUp();
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('I approved it.'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<UserCubit>().resendEmailVerification();
                          },
                    child: const Text(
                        "If you haven't received an email, please resend it."),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
