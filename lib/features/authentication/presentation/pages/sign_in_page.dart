import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tv_app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:tv_app/features/authentication/presentation/pages/verify_email_page.dart';
import '../../../series/presentation/widgets/show_exit_dialog.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/authentication/authentication_cubit.dart';
import '../cubit/user/user_cubit.dart';
import '../widgets/snack_bar_error.dart';
import 'forgot_password_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameOrEmailController =
  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldGlobalKey =
  GlobalKey<ScaffoldState>();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else if (!didPop) {
          showExitDialog(context);
        }
      },
      child: Scaffold(
        key: _scaffoldGlobalKey,
        body: BlocListener<UserCubit, UserState>(
          listenWhen: (prev, curr) {
            if (prev is EmailVerificationRequired &&
                curr is EmailVerificationRequired) {
              return false;
            }
            return curr is EmailVerificationRequired ||
                curr is UserSuccess ||
                curr is UserFailure;
          },
          listener: (context, userState) {
            if (userState is EmailVerificationRequired) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => VerifyEmailPage()));
            } else if (userState is UserSuccess) {
              BlocProvider.of<AuthenticationCubit>(context).loggedIn();

              if (kDebugMode) {
                print(
                    "BlocProvider.of<AuthenticationCubit>(context).loggedIn(); **********************************************");
              }
            } else if (userState is UserFailure) {
              snackBarError(
                msg: "The email/the username\nor password is incorrect.",
                scaffoldState: _scaffoldGlobalKey,
              );
            }
          },
          child: BlocListener<AuthenticationCubit, AuthenticationState>(
            listenWhen: (p, c) => c is Authenticated,
            listener: (context, state) {
              Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);

              if (kDebugMode) {
                print(
                    "SingInPage const MainPage(), **********************************************");
              }
            },
            child: _bodyWidget(),
          ),
        ),
      ),
    );
  }

  _bodyWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              SvgPicture.asset(
                "assets/images/undraw_mobile-login_4ntr.svg",
                height: 152,
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 52,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: TextField(
                  controller: _usernameOrEmailController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email or username.',
                    border: InputBorder.none,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 52,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: TextField(
                  controller: _passwordController,
                  cursorColor: Colors.black,
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    labelText: 'Enter your password.',
                    border: InputBorder.none,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      tooltip: _isPasswordObscured
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  submitSignIn();
                },
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade700,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "I forgot my password.",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitSignIn() {
    if (_usernameOrEmailController.text.isEmpty) {
      snackBarError(
        msg: "The email/the username is empty!",
        scaffoldState: _scaffoldGlobalKey,
      );
    } else if (_usernameOrEmailController.text.contains(" ")) {
      snackBarError(
        msg: "An email/an username\ncan not contain spaces.",
        scaffoldState: _scaffoldGlobalKey,
      );
    } else if (_passwordController.text.isEmpty) {
      snackBarError(
        msg: "The password is empty!",
        scaffoldState: _scaffoldGlobalKey,
      );
    } else {
      BlocProvider.of<UserCubit>(context).submitSignIn(
        user: UserEntity(
          username: _usernameOrEmailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
