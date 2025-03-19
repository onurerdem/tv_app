import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/authentication/presentation/cubit/authentication/authentication_cubit.dart';
import 'package:tv_app/features/authentication/presentation/pages/sign_in_page.dart';

import '../../../navigation/presentation/pages/main_page.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/user/user_cubit.dart';
import '../widgets/snack_bar_error.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: BlocConsumer<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserSuccess) {
            return BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, authenticationState) {
                if (authenticationState is Authenticated) {
                  return MainPage();
                } else {
                  return _bodyWidget();
                }
              },
            );
          }

          return _bodyWidget();
        },
        listener: (context, userState) {
          if (userState is UserSuccess) {
            BlocProvider.of<AuthenticationCubit>(context).loggedIn();
          }
          if (userState is UserFailure) {
            snackBarError(
              msg: "The email or password is incorrect.",
              scaffoldState: _globalKey,
            );
          }
          if (userState is UserEmailAlreadyExists) {
            snackBarError(
              msg:
                  "This email address is already registered.\nPlease use a different email address.",
              scaffoldState: _globalKey,
            );
          }
          if (userState is UserUsernameAlreadyExists) {
            snackBarError(
              msg:
                  "This username is already taken.\nPlease choose a different username.",
              scaffoldState: _globalKey,
            );
          }
        },
      ),
    );
  }

  _bodyWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    ),
                  );
                },
                child: Container(
                  height: 52,
                  width: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withValues(alpha: 0.6)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                height: 52,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: TextField(
                  controller: _usernameController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Enter an username.',
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
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email.',
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
                  obscureText: true,
                  controller: _passwordController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Enter your password.',
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
              GestureDetector(
                onTap: () {
                  submitSignUp();
                },
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade700,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create New Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitSignUp() {
    if (_usernameController.text.isEmpty) {
      snackBarError(
        msg: "The username is empty!",
        scaffoldState: _globalKey,
      );
    } else if (_usernameController.text.contains(" ")) {
      snackBarError(
        msg: "An username can not contain spaces.",
        scaffoldState: _globalKey,
      );
    } else if (_usernameController.text.contains("@")) {
      snackBarError(
        msg: "An username can not contain '@'.",
        scaffoldState: _globalKey,
      );
    } else if (_usernameController.text.length > 15) {
      snackBarError(
        msg: "Your username can not have\nmore than 15 characters!",
        scaffoldState: _globalKey,
      );
    } else if (_emailController.text.isEmpty) {
      snackBarError(
        msg: "The email is empty!",
        scaffoldState: _globalKey,
      );
    } else if (_emailController.text.contains(" ")) {
      snackBarError(
        msg: "An email can not contain spaces.",
        scaffoldState: _globalKey,
      );
    } else if (emailCheck(_emailController.text) == false) {
      snackBarError(
        msg: "The e-mail must be as follows:\nexample@mail.com",
        scaffoldState: _globalKey,
      );
    } else if (_passwordController.text.isEmpty) {
      snackBarError(
        msg: "The password is empty!",
        scaffoldState: _globalKey,
      );
    } else if (_passwordController.text.length < 3 ||
        _passwordController.text.length > 15) {
      snackBarError(
        msg:
            "Your password can not have less than\n3 characters or more than 15 characters!",
        scaffoldState: _globalKey,
      );
    } else {
      BlocProvider.of<UserCubit>(context).submitSignUp(
        user: UserEntity(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}

bool emailCheck(String text) {
  int atIndex = text.indexOf('@');
  if (atIndex == -1) {
    return false;
  }

  int dotIndex = text.indexOf('.', atIndex + 1);
  if (dotIndex == -1) {
    return false;
  }

  if (atIndex == 0) {
    return false;
  }

  if (dotIndex - atIndex <= 1) {
    return false;
  }

  if (dotIndex == text.length - 1) {
    return false;
  }

  return true;
}
