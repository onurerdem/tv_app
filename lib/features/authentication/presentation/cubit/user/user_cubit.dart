import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/remote/firebase_remote_data_source_impl.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usacases/forgot_password_usecase.dart';
import '../../../domain/usacases/get_create_current_user_usecase.dart';
import '../../../domain/usacases/sign_in_usecase.dart';
import '../../../domain/usacases/sign_up_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  UserCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.getCreateCurrentUserUseCase,
    required this.forgotPasswordUseCase,
  }) : super(UserInitial());

  Future<void> submitSignIn({required UserEntity user}) async {
    emit(UserLoading());
    try {
      await signInUseCase.call(user);
      emit(UserSuccess());
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> submitSignUp({required UserEntity user}) async {
    emit(UserLoading());

    bool isTheUsernameAvailableValue = false;

    try {
      isTheUsernameAvailableValue = await isTheUsernameAvailable(user.username!);
      if (isTheUsernameAvailableValue) {
        emit(UserUsernameAlreadyExists());
        return;
      }

      await signUpUseCase.call(user);
      await getCreateCurrentUserUseCase.call(user);
      emit(UserSuccess());
    } on SocketException catch (_) {
      emit(UserFailure());
    } on FirebaseAuthException catch (_) {
      if (_.code == 'email-already-in-use') {
        emit(UserEmailAlreadyExists());
      } else {
        emit(UserFailure());
      }
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> submitForgotPassword({required String emailOrUsername}) async {
    emit(ForgotPasswordLoading());

    bool isTheUsernameAvailableValue = false;
    bool isTheEmailRegisteredValue = false;

    try {
      if (!emailOrUsername.contains('@')) {
        isTheUsernameAvailableValue = await isTheUsernameAvailable(emailOrUsername);
        if (!isTheUsernameAvailableValue) {
          emit(
            ForgotPasswordFailure(errorMessage: "Username not found."),
          );
          return;
        }
      } else {
        isTheEmailRegisteredValue = await isTheEmailRegistered(emailOrUsername);
        if (!isTheEmailRegisteredValue) {
          emit(
            ForgotPasswordFailure(errorMessage: "E-mail not found."),
          );
          return;
        }
      }

      await forgotPasswordUseCase.call(emailOrUsername);
      emit(ForgotPasswordSuccess());
    } on SocketException catch (_) {
      emit(ForgotPasswordFailure());
    } on FirebaseAuthException catch (_) {
      if (_.code == 'user-not-found') {
        emit(
          ForgotPasswordFailure(errorMessage: "Username or e-mail not found."),
        );
      } else {
        emit(ForgotPasswordFailure());
      }
    } catch (_) {
      emit(ForgotPasswordFailure());
    }
  }
}
