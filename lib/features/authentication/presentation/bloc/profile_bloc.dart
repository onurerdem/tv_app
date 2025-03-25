import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_app/features/authentication/domain/usacases/get_user_profile_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUsecase;

  ProfileBloc(this.getUserProfileUsecase) : super(ProfileInitial()) {
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
  }
}
