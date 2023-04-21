import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_screen.dart';
import 'storage.dart';
import 'routes.dart';
import 'exercise.dart';

import 'authentication/authentication_bloc.dart';
import 'courses/courses_page.dart';
import 'courses/courses_bloc.dart';
import 'categories/categories_bloc.dart';
import 'categories/categories_page.dart';
import 'authentication/login_page.dart';
import 'registration/registration_page.dart';

import 'api/auth_api_service.dart';
import 'api/courses_api_service.dart';
import 'api/categories_api_service.dart';
import 'api/exercise_api_service.dart';

void main() async {
  await StorageService.initHive();
  final authApiService = AuthApiService();
  final coursesApiService = CoursesApiService();
  final categoriesApiService = CategoriesApiService();
  final exerciseApiService = ExerciseApiService();
  runApp(MyApp(
      authApiService: authApiService,
      coursesApiService: coursesApiService,
      categoriesApiService: categoriesApiService,
      exerciseApiService: exerciseApiService));
}

class MyApp extends StatelessWidget {
  final AuthApiService authApiService;
  final CoursesApiService coursesApiService;
  final CategoriesApiService categoriesApiService;
  final ExerciseApiService exerciseApiService;

  const MyApp({
    required this.authApiService,
    required this.coursesApiService,
    required this.categoriesApiService,
    required this.exerciseApiService,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        storageService: StorageService(),
        authApiService: authApiService,
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.login: (context) =>
              LoginPage(authApiService: authApiService),
          AppRoutes.register: (context) =>
              RegistrationPage(authApiService: authApiService),
          AppRoutes.courses: (context) => BlocProvider(
              create: (context) =>
                  CoursesBloc(coursesApiService: coursesApiService),
              child: const CoursesPage()),
          AppRoutes.categories: (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return CategoriesPage(
              courseId: arguments['courseId'],
              courseName: arguments['courseName'],
              token: arguments['token'],
              categoriesApiService: categoriesApiService,
            );
          },
          AppRoutes.exercise: (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return ExercisePage(categoryId: arguments['categoryId']);
          },
        },
      ),
    );
  }
}
