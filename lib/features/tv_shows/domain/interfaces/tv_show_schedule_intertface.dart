import 'package:equatable/equatable.dart';

class ITvShowSchedule extends Equatable {
  const ITvShowSchedule({
    required this.time,
    required this.days,
  });

  final String? time;
  final List<String>? days;

  @override
  List<Object?> get props => [
        time,
        days,
      ];
}