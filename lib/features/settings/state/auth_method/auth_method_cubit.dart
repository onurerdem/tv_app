import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/features/settings/data/auth_method_repository.dart';
import 'package:tv_app/features/settings/domain/enums/auth_method_type_enum.dart';
import 'package:tv_app/features/settings/domain/events/auth_method_events.dart';
import 'package:tv_app/features/settings/state/auth_method/auth_method_state.dart';

class AuthMethodCubit extends Cubit<AuthMethodState> {
  AuthMethodCubit({
    required this.authMethodRepository,
    required this.eventBus,
  }) : super(AuthMethodLoadingState());

  final AuthMethodRepository authMethodRepository;
  final EventBus eventBus;

  StreamSubscription? _authMethodEventSubscription;

  Future<void> initialize() async {
    _authMethodEventSubscription = eventBus.on<AuthMethodUpdateEvent>().listen(
          (AuthMethodUpdateEvent event) => _updateAuthEvent(
            authMethodTypes: event.authMethodTypes,
            authPin: event.authPin,
          ),
        );
  }

  @override
  Future<void> close() async {
    await _authMethodEventSubscription?.cancel();
    return super.close();
  }

  Future<void> getAuthMethod() async {
    try {
      emit(AuthMethodLoadingState());

      final String? authPin = await authMethodRepository.getAuthPin();

      final List<AuthMethodType> authMethodTypes =
          await authMethodRepository.getAuthMethods();

      emit(AuthMethodLoadedState(
          authPin: authPin, authMethodTypes: authMethodTypes));
    } catch (e, _) {
      emit(AuthMethodErrorState());
    }
  }

  void _updateAuthEvent({
    required List<AuthMethodType> authMethodTypes,
    required String? authPin,
  }) {
    emit(AuthMethodLoadedState(
      authMethodTypes: authMethodTypes,
      authPin: authPin,
    ));
  }
}