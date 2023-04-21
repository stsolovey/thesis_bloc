// categories_event.dart
import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchCategories extends CategoriesEvent {
  final String courseId;
  final String token;

  const FetchCategories(this.courseId, this.token);

  @override
  List<Object> get props => [courseId, token];
}
