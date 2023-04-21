abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final Map<String, dynamic> exerciseData;

  ExerciseLoaded(this.exerciseData);
}

class ExerciseWaitingForResponse extends ExerciseState {}

class AnswerSent extends ExerciseState {
  final Map<String, dynamic> response;

  AnswerSent(this.response);
}

class ExerciseError extends ExerciseState {
  final String message;

  ExerciseError(this.message);
}

class ExerciseUnauthenticated extends ExerciseState {}
