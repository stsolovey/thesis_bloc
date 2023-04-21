import 'dart:async';
import 'package:bloc/bloc.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';
import '../api/exercise_api_service.dart';
import '../storage.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseApiService _exerciseApiService;

  ExerciseBloc(this._exerciseApiService) : super(ExerciseInitial());

  Stream<ExerciseState> mapEventToState(ExerciseEvent event) async* {
    if (event is GetExercise) {
      yield ExerciseLoading();
      try {
        final token = await StorageService.getToken();
        if (token == null) {
          await StorageService.deleteToken();
          yield ExerciseUnauthenticated();
        } else {
          final Map<String, dynamic> response =
              await _exerciseApiService.getExercise(token, event.categoryId);
          yield ExerciseLoaded(response);
        }
      } catch (e) {
        yield ExerciseError(e.toString());
      }
    } else if (event is SendAnswer) {
      yield ExerciseWaitingForResponse();
      try {
        final token = await StorageService.getToken();
        if (token == null) {
          await StorageService.deleteToken();
          yield ExerciseUnauthenticated();
        } else {
          final response = await _exerciseApiService.sendAnswer(
              token, event.exerciseId, event.userInput);
          yield AnswerSent(response);
        }
      } catch (e) {
        yield ExerciseError(e.toString());
      }
    }
  }
}
