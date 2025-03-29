import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(selectedIndex: 0, history: [0])) {
    on<ChangeTabEvent>(_onChangeTabEvent);
    on<GoBackEvent>(_onGoBackEvent);
  }

  void _onChangeTabEvent(ChangeTabEvent event, Emitter<NavigationState> emit) {
    if (state.selectedIndex == event.index) return;

    List<int> newHistory = List.from(state.history)..add(event.index);
    emit(state.copyWith(selectedIndex: event.index, history: newHistory));
  }

  void _onGoBackEvent(GoBackEvent event, Emitter<NavigationState> emit) {
    if (state.history.length > 1) {
      List<int> newHistory = List.from(state.history)..removeLast();
      int previousIndex = newHistory.last;
      emit(state.copyWith(selectedIndex: previousIndex, history: newHistory));
    } else {
      emit(state);
    }
  }
}
