// courses_event.dart
import 'package:equatable/equatable.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object> get props => [];
}

class FetchCourses extends CoursesEvent {}
