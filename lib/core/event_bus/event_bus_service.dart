import 'dart:async';

class EventBus {
  final StreamController _streamController = StreamController.broadcast();

  Stream<T> on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void fire(EventBusMessage message) {
    _streamController.add(message);
  }

  void destroy() {
    _streamController.close();
  }
}

abstract class EventBusMessage {}