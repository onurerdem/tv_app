import 'package:injectable/injectable.dart';
import 'package:tv_app/core/event_bus/event_bus_service.dart';

@module
abstract class EventBusModule {
  @lazySingleton
  EventBus eventBus() => EventBus();
}