import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_bloc.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_event.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_state.dart';
import 'package:tv_app/features/authentication/presentation/widgets/snack_bar_error.dart';

import '../widgets/snack_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool _isOldPasswordObscured = true;
  bool _isNewPasswordObscured = true;
  bool _isConfirmNewPasswordObscured = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmNewPassword = _confirmNewPasswordController.text;

    if (oldPassword.isEmpty) {
      snackBarError(
        msg: "The old password is empty!",
        scaffoldState: _globalKey,
      );
    } else if (newPassword.isEmpty) {
      snackBarError(
        msg: "The new password is empty!",
        scaffoldState: _globalKey,
      );
    } else if (newPassword.length < 6 || newPassword.length > 15) {
      snackBarError(
        msg: "Your new password can not have less than\n6 characters or more than 15 characters!",
        scaffoldState: _globalKey,
      );
    } else if (confirmNewPassword.isEmpty) {
      snackBarError(
        msg: "The field to re-enter the new password is empty!",
        scaffoldState: _globalKey,
      );
    } else if (newPassword != confirmNewPassword) {
      snackBarError(
        msg: "New passwords do not match.",
        scaffoldState: _globalKey,
      );
    } else if (oldPassword == newPassword) {
      snackBarError(
        msg: "The old password and the new\npassword cannot be the same!",
        scaffoldState: _globalKey,
      );
    } else {
      context.read<ProfileBloc>().add(
        ChangePasswordEvent(
          oldPassword: oldPassword,
          newPassword: newPassword,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(title: const Text("Change Password")),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            snackBar(
              msg: "Password updated successfully.",
              scaffoldState: _globalKey,
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordError) {
            snackBarError(
              msg: state.message,
              scaffoldState: _globalKey,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: _oldPasswordController,
                cursorColor: Colors.black,
                obscureText: _isOldPasswordObscured,
                decoration: InputDecoration(
                  labelText: "Enter your old password.",
                  border: InputBorder.none,
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isOldPasswordObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    tooltip: _isOldPasswordObscured ? 'Show password' : 'Hide password',
                    onPressed: () {
                      setState(() {
                        _isOldPasswordObscured = !_isOldPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                cursorColor: Colors.black,
                obscureText: _isNewPasswordObscured,
                decoration: InputDecoration(
                  labelText: "Enter your new password.",
                  border: InputBorder.none,
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    tooltip: _isNewPasswordObscured ? 'Show password' : 'Hide password',
                    onPressed: () {
                      setState(() {
                        _isNewPasswordObscured = !_isNewPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmNewPasswordController,
                cursorColor: Colors.black,
                obscureText: _isConfirmNewPasswordObscured,
                decoration: InputDecoration(
                  labelText: "Enter your new password again.",
                  border: InputBorder.none,
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmNewPasswordObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey.shade600,
                    ),
                    tooltip: _isConfirmNewPasswordObscured ? 'Show password' : 'Hide password',
                    onPressed: () {
                      setState(() {
                        _isConfirmNewPasswordObscured = !_isConfirmNewPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width / 2,
                    44,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
