abstract class ExerciseEvent {}

class GetExercise extends ExerciseEvent {
  final String categoryId;

  GetExercise({required this.categoryId});

  List<Object> get props => [categoryId];
}

class SendAnswer extends ExerciseEvent {
  final String exerciseId;
  final String userInput;

  SendAnswer(this.exerciseId, this.userInput);
}
