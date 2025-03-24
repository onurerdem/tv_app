import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user/user_cubit.dart';
import '../widgets/snack_bar.dart';
import '../widgets/snack_bar_error.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailOrUsernameController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldGlobalKey =
      GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(title: const Text("I forgot my password.")),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            snackBar(
              msg: "Password reset email has been sent.\nPlease check your email.",
              scaffoldState: _scaffoldGlobalKey,
            );
          }
          if (state is ForgotPasswordFailure) {
            snackBarError(
              msg: state.errorMessage ?? "Failed to send password reset email.",
              scaffoldState: _scaffoldGlobalKey,
            );
          }
        },
        builder: (context, state) {
          return _bodyWidget(state is ForgotPasswordLoading);
        },
      ),
    );
  }

  Widget _bodyWidget(bool isLoading) {
    return Center(
      child: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter your email address or username to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailOrUsernameController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Email or username.',
                  border: OutlineInputBorder(),
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submitForgotPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  foregroundColor: Colors.black,
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForgotPassword() {
    String emailOrUsername = _emailOrUsernameController.text;
    if (emailOrUsername.isEmpty) {
      snackBarError(
        msg: "The email/the username is empty!",
        scaffoldState: _scaffoldGlobalKey,
      );
      return;
    } else if (emailOrUsername.contains(" ")) {
      snackBarError(
        msg: "An email/an username\ncan not contain spaces.",
        scaffoldState: _scaffoldGlobalKey,
      );
    } else {
      BlocProvider.of<UserCubit>(context)
          .submitForgotPassword(emailOrUsername: emailOrUsername);
    }
  }
}
