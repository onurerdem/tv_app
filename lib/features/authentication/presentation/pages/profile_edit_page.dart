import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/authentication/domain/entities/user_entity.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_bloc.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_event.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_state.dart';

import '../../../navigation/presentation/bloc/navigation_bloc.dart';
import '../../../navigation/presentation/pages/main_page.dart';
import '../widgets/snack_bar.dart';
import '../widgets/snack_bar_error.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;
  const EditProfilePage({super.key, required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _statusController;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _statusController = TextEditingController(text: widget.user.status);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_nameController.text.length > 20) {
      snackBarError(
        msg: "Your username can not have\nmore than 20 characters!",
        scaffoldState: _globalKey,
      );
    } else if (_usernameController.text.isEmpty) {
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
    } else if (_statusController.text.length > 300) {
      snackBarError(
        msg: "Your username can not have\nmore than 300 characters!",
        scaffoldState: _globalKey,
      );
    } else {
      final updatedUser = UserEntity(
        uid: widget.user.uid,
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        status: _statusController.text,
      );
      context.read<ProfileBloc>().add(UpdateProfileEvent(updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: BlocProvider.of<NavigationBloc>(context),
                child: MainPage(),
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              snackBar(
                msg: "Profile updated successfully.",
                scaffoldState: _globalKey,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<NavigationBloc>(context),
                    child: MainPage(),
                  ),
                ),
                    (Route<dynamic> route) => false,
              );
            } else if (state is ProfileUpdateError) {
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
                  controller: _nameController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: InputBorder.none,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: InputBorder.none,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: InputBorder.none,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _statusController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: InputBorder.none,
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProfile,
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
                    "Update Profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
