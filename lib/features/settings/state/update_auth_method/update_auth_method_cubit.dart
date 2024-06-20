import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/features/settings/data/auth_method_repository.dart';
import 'package:tv_app/features/settings/domain/enums/auth_method_type_enum.dart';
import 'package:tv_app/features/settings/domain/events/auth_method_events.dart';
import 'package:tv_app/features/settings/state/update_auth_method/update_auth_method_state.dart';

class UpdateAuthMethodCubit extends Cubit<UpdateAuthMethodState> {
  UpdateAuthMethodCubit({
    required this.authMethodRepository,
    required this.eventBus,
  }) : super(UpdateAuthMethodInitialState());

  final AuthMethodRepository authMethodRepository;
  final EventBus eventBus;

  Future<UpdateAuthMethodState> updateAuthMethod({
    required List<AuthMethodType> authMethodTypes,
    required String? authPin,
  }) async {
    try {
      emit(UpdateAuthMethodLoadingState());

      if (authPin != null) {
        await authMethodRepository.saveAuthPin(
          authPin: authPin,
        );
      }

      await authMethodRepository.saveAuthMethod(
        authMethodTypes: authMethodTypes,
      );

      eventBus.fire(AuthMethodUpdateEvent(
        authMethodTypes: authMethodTypes,
        authPin: authPin,
      ));

      emit(UpdateAuthMethodSuccessState());
      return state;
    } catch (e) {
      emit(UpdateAuthMethodErrorState());
      return state;
    }
  }
}