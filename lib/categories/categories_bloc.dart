// categories_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'categories_event.dart';
import 'categories_state.dart';
import '../api/categories_api_service.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesApiService categoriesApiService;

  CategoriesBloc({required this.categoriesApiService})
      : super(CategoriesInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoriesState> emit) async {
    emit(CategoriesLoading());
    try {
      final categories = await categoriesApiService.getCategories(
        event.token,
        event.courseId,
      );
      categories
          .sort((a, b) => a['category_weight'].compareTo(b['category_weight']));
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(const CategoriesError('Failed to fetch categories'));
    }
  }
}
