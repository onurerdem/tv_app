part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  final int selectedIndex;
  final List<int> history;

  const NavigationState({required this.selectedIndex, required this.history});

  NavigationState copyWith({int? selectedIndex, List<int>? history}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      history: history ?? this.history,
    );
  }

  @override
  List<Object> get props => [selectedIndex, history];
}
