import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_app/features/authentication/domain/usacases/get_user_profile_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usacases/change_password_use_case.dart';
import '../../domain/usacases/update_user_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUsecase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  ProfileBloc(
    this.getUserProfileUsecase,
    this.updateUserProfileUseCase,
    this.changePasswordUseCase,
  ) : super(ProfileInitial()) {
    on<GetProfileEvent>(
      (event, emit) async {
        emit(ProfileLoading());
        Either<Failure, UserEntity> result = await getUserProfileUsecase(NoParams());
        result.fold(
          (failure) => emit(const ProfileError("Failed to load profile.")),
          (user) => emit(ProfileLoaded(user)),
        );
      },
    );
    on<UpdateProfileEvent>(
      (event, emit) async {
        emit(ProfileUpdating());
        Either<Failure, UserEntity> result = await updateUserProfileUseCase(event.user);
        result.fold(
          (failure) => emit(const ProfileUpdateError("Failed to update profile.")),
          (user) => emit(ProfileUpdateSuccess(user)),
        );
      },
    );
    on<ChangePasswordEvent>(
      (event, emit) async {
        emit(ChangingPassword());
        final result = await changePasswordUseCase(
          ChangePasswordParams(
            oldPassword: event.oldPassword,
            newPassword: event.newPassword,
          ),
        );
        result.fold(
          (failure) {
              if (failure is OldPasswordWrongFailure) {
                emit(const ChangePasswordError("You entered your old password incorrectly!"));
              } else {
                emit(const ChangePasswordError("Failed to update password."));
              }
            },
          (_) => emit(const ChangePasswordSuccess()),
        );
      },
    );
  }
}
