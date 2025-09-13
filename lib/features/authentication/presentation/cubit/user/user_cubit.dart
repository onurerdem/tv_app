import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
      final u = FirebaseAuth.instance.currentUser;
      await u?.reload();
      if (u != null && !u.emailVerified) {
        emit(EmailVerificationRequired());
        if (kDebugMode) {
          print(
              "EmailVerificationRequired **********************************************************");
        }
      } else {
        emit(UserSuccess());
        if (kDebugMode) {
          print(
              "UserCubit UserSuccess **********************************************************");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        emit(UserFailure());
        if (kDebugMode) {
          print(
              "FirebaseAuthException $e **********************************************************");
        }
      } else {
        emit(UserFailure());
        if (kDebugMode) {
          print(
              "FirebaseAuthException2 $e **********************************************************");
        }
      }
    } on SocketException catch (_) {
      emit(UserFailure());
      if (kDebugMode) {
        print(
            "SocketException: $_ **********************************************************");
      }
    } catch (_) {
      emit(UserFailure());
      if (kDebugMode) {
        print(
            "Catch: $_ **********************************************************");
      }
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

      final current = FirebaseAuth.instance.currentUser;
      if (kDebugMode) {
        print("Current: $current");
      }
      if (current != null && !current.emailVerified) {
        try {
          await current.sendEmailVerification();
          if (kDebugMode) print("sendEmailVerification succeeded");
          emit(EmailVerificationRequired());
          if (kDebugMode) {
            print(
                "emit(EmailVerificationRequired()); **********************************************************");
          }
          return;
        } catch (e) {
          if (kDebugMode) print("sendEmailVerification failed: $e");
        }
      }

      if (kDebugMode) {
        print(
            "emit(UserSuccess()); *****************************************************************************");
      }
      emit(UserSuccess());
      if (kDebugMode) {
        print(
            "emit(UserSuccess()); 2 *****************************************************************************");
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("SocketException: $_");
      }
      emit(UserFailure());
    } on FirebaseAuthException catch (_) {
      if (_.code == 'email-already-in-use') {
        if (kDebugMode) {
          print("FirebaseAuthException: $_");
        }
        emit(UserEmailAlreadyExists());
      } else {
        if (kDebugMode) {
          print("FirebaseAuthException2: $_");
        }
        emit(UserFailure());
      }
    } catch (_) {
      if (kDebugMode) {
        print("Catch: $_");
      }
      emit(UserFailure());
    }
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print(
            "checkEmailVerified user == null UserIsNull(${DateTime.now()}) **********************************************************");
      }
      return emit(UserIsNull(DateTime.now()));
    }
    await user.reload();

    if (kDebugMode) {
      print("checkEmailVerified user.emailVerified: ${user.emailVerified} **********************************************************");
      print("checkEmailVerified user.email: ${user.email} **********************************************************");
      print("checkEmailVerified await user.reload(): ${user.reload()} **********************************************************");
    }

    if (user.emailVerified) {
      emit(UserSuccess());
      if (kDebugMode) {
        print(
            "checkEmailVerified user.emailVerified UserSuccess **********************************************************");
      }
    } else {
      emit(UserVerificationFailed(DateTime.now()));
      if (kDebugMode) {
        print(
            "checkEmailVerified user.emailVerified UserVerificationFailed(${DateTime.now()}) **********************************************************");
      }
    }
  }

  Future<void> resendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print(
            "resendEmailVerification user == null UserIsNull(${DateTime.now()}) **********************************************************");
      }
      return emit(UserIsNull(DateTime.now()));
    }
    try {
      if (!user.emailVerified) {
        await user.sendEmailVerification(); // parametresiz
        emit(ResendEmailVerificationSuccess(DateTime.now()));
      }

      if (kDebugMode) {
        print(
            "resendEmailVerification ResendEmailVerificationSuccess(${DateTime.now()}) **********************************************************");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        emit(TooManyRequests(DateTime.now()));
        if (kDebugMode) {
          print(
              "resendEmailVerification TooManyRequests(${DateTime.now()}): $e **********************************************************");
        }
      } else {
        emit(ResendEmailVerificationFailure(DateTime.now()));
        if (kDebugMode) {
          print(
              "resendEmailVerification ResendEmailVerificationFailure(${DateTime.now()}) FirebaseAuthException: $e **********************************************************");
        }
      }
    } catch (e) {
      emit(ResendEmailVerificationFailure(DateTime.now()));
      if (kDebugMode) {
        print(
            "resendEmailVerification ResendEmailVerificationFailure(${DateTime.now()}): $e **********************************************************");
      }
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
            const ForgotPasswordFailure(errorMessage: "Username not found."),
          );
          return;
        }
      } else {
        isTheEmailRegisteredValue = await isTheEmailRegistered(emailOrUsername);
        if (!isTheEmailRegisteredValue) {
          emit(
            const ForgotPasswordFailure(errorMessage: "E-mail not found."),
          );
          return;
        }
      }

      await forgotPasswordUseCase.call(emailOrUsername);
      emit(ForgotPasswordSuccess());
    } on SocketException catch (_) {
      emit(const ForgotPasswordFailure());
    } on FirebaseAuthException catch (_) {
      if (_.code == 'user-not-found') {
        emit(
          const ForgotPasswordFailure(
              errorMessage: "Username or e-mail not found."),
        );
      } else {
        emit(const ForgotPasswordFailure());
      }
    } catch (_) {
      emit(const ForgotPasswordFailure());
    }
  }
}
