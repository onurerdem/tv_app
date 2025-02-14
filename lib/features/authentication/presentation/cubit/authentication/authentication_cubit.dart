import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usacases/get_current_uid_usecase.dart';
import '../../../domain/usacases/is_sign_in_usecase.dart';
import '../../../domain/usacases/sign_out_usecase.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;
  AuthenticationCubit({required this.isSignInUseCase,required this.signOutUseCase,required this.getCurrentUidUseCase}) : super(AuthenticationInitial());

  Future<void> appStarted()async{
    try{
      final isSignIn=await isSignInUseCase.call();
      if (isSignIn){
        final uid=await getCurrentUidUseCase.call();
        emit(Authenticated(uid: uid));
      }else{
        emit(UnAuthenticated());
      }


    }on SocketException catch(_){
      emit(UnAuthenticated());
    }


  }


  Future<void> loggedIn()async{
    try{
      final uid=await getCurrentUidUseCase.call();
      emit(Authenticated(uid: uid));
    }on SocketException catch(_){
      emit(UnAuthenticated());
    }

  }
  Future<void> loggedOut()async{
    try{
      await signOutUseCase.call();
      emit(UnAuthenticated());
    }on SocketException catch(_){
      emit(UnAuthenticated());
    }

  }
}