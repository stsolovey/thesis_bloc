// courses_bloc.dart

import 'package:bloc/bloc.dart';
import '../api/categories_api_service.dart';
import 'courses_event.dart';
import 'courses_state.dart';
import '../api/courses_api_service.dart';
import '../storage.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CoursesApiService coursesApiService;

  CoursesBloc({required this.coursesApiService}) : super(CoursesInitial()) {
    on<FetchCourses>((event, emit) async {
      emit(CoursesLoading());
      try {
        final token = await StorageService.getToken();
        if (token == null) {
          await StorageService.deleteToken();
          emit(const CoursesError("Token not found"));
        } else {
          final response = await coursesApiService.getCourses(token);
          if (response['status']) {
            emit(CoursesLoaded(response['message']));
            await StorageService.saveCourses(response['message']);
          } else {
            await StorageService.deleteToken();
            emit(const CoursesError("Failed to fetch courses"));
          }
        }
      } catch (e) {
        emit(CoursesError(e.toString()));
      }
    });
  }

  // Add this getter to expose categoriesApiService
  CategoriesApiService get categoriesApiService =>
      coursesApiService.categoriesApiService;
}
