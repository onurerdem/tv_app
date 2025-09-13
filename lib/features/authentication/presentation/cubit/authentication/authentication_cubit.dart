import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usacases/get_current_uid_usecase.dart';
import '../../../domain/usacases/is_sign_in_usecase.dart';
import '../../../domain/usacases/sign_out_usecase.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;

  late final StreamSubscription<User?> _authSub;
  Timer? _expiryTimer;

  AuthenticationCubit({
    required this.isSignInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUidUseCase,
  }) : super(AuthenticationInitial()) {
    _authSub = FirebaseAuth.instance.idTokenChanges().listen(_onUserChanged);
  }

  Future<void> appStarted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (kDebugMode) {
        print("user: $user");
      }
      if (user.emailVerified) {
        if (kDebugMode) {
          print("user.emailVerified: ${user.emailVerified}");
        }
        emit(Authenticated(uid: user.uid));
      } else {
        if (kDebugMode) {
          print("user.emailVerified2: ${user.emailVerified}");
        }
        emit(UnAuthenticated());
      }
    } else {
      if (kDebugMode) {
        print("user: null ***************************************************************");
      }
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final u = FirebaseAuth.instance.currentUser;
      await u?.reload();
      if (u != null && u.emailVerified) {
        if (kDebugMode) {
          print("u: $u");
        }
        emit(Authenticated(uid: u.uid));
      } else {
        if (kDebugMode) {
          print("u: null or u.emailVerified: ${u?.emailVerified} ***************************************************************");
        }
        emit(UnAuthenticated());
      }

    } on SocketException catch (_) {
      if (kDebugMode) {
        print("SocketException: $SocketException **** $_");
      }
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } on SocketException catch (_) {
      emit(UnAuthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    _expiryTimer?.cancel();
    return super.close();
  }

  void _onUserChanged(User? user) async {
    _expiryTimer?.cancel();

    if (user == null) {
      if (kDebugMode) {
        print("USER: null ***************************************************************");
      }
      emit(UnAuthenticated());
    } else {
      if (kDebugMode) {
        print("USER: $user");
      }
      await user.reload();
      if (user.emailVerified) {
        if (kDebugMode) {
          print("user.emailVerified: ${user.emailVerified}");
        }
        emit(Authenticated(uid: user.uid));
        _scheduleTokenExpiryCheck(user);
      } else {
        if (kDebugMode) {
          print("user.emailVerified: ${user.emailVerified}");
        }
        emit(UnAuthenticated());
      }
    }
  }

  Future<void> _scheduleTokenExpiryCheck(User user) async {
    final idTokenResult = await user.getIdTokenResult();
    if (kDebugMode) {
      print("idTokenResult: $idTokenResult");
    }
    final exp = idTokenResult.expirationTime;
    if (kDebugMode) {
      print("EXP: $exp");
    }
    if (exp == null) {
      if (kDebugMode) {
        print("EXP: null ***************************************************************");
      }
      await _forceSignOut();
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
      await _forceSignOut();
      return;
    }
    _expiryTimer = Timer(duration, () {
      if (kDebugMode) {
        print("TIMER: $duration");
      }
      _forceSignOut();
    });
  }

  Future<void> _forceSignOut() async {
    try {
      await signOutUseCase.call();
    } catch (_) {}
    emit(UnAuthenticated());
  }
}
