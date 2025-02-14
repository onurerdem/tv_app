import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usacases/get_create_current_user_usecase.dart';
import '../../../domain/usacases/sign_in_usecase.dart';
import '../../../domain/usacases/sign_up_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignInUseCase signInUseCase;
  final SignUPUseCase signUPUseCase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUseCase;
  UserCubit({required this.signUPUseCase,required this.signInUseCase,required this.getCreateCurrentUserUseCase}) : super(UserInitial());

  Future<void> submitSignIn({required UserEntity user})async{
    emit(UserLoading());
    try {
      await signInUseCase.call(user);
      emit(UserSuccess());
    }on SocketException catch(_){
      emit(UserFailure());
    } catch(_){
      emit(UserFailure());
    }
  }
  Future<void> submitSignUp({required UserEntity user})async{
    emit(UserLoading());
    try {
      await signUPUseCase.call(user);
      await getCreateCurrentUserUseCase.call(user);
      emit(UserSuccess());
    }on SocketException catch(_){
      emit(UserFailure());
    } catch(_){
      emit(UserFailure());
    }

  }
}