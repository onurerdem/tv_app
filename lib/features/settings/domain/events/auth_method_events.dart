import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/features/settings/domain/enums/auth_method_type_enum.dart';

class AuthMethodUpdateEvent extends EventBusMessage {
  AuthMethodUpdateEvent({
    required this.authMethodTypes,
    required this.authPin,
  });

  final List<AuthMethodType> authMethodTypes;
  final String? authPin;
}