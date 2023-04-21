// courses_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../categories/categories_page.dart';
import '../storage.dart';
import 'courses_bloc.dart';
import 'courses_event.dart';
import 'courses_state.dart';
import '../routes.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(FetchCourses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logoutAndNavigate(context),
          ),
        ],
      ),
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesLoaded) {
            return ListView.builder(
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.courses[index]['course_name']),
                  subtitle: Text(
                      '${state.courses[index]['from_language']} - ${state.courses[index]['learning_language']}'),
                  onTap: () => _onCourseTapped(
                    context,
                    state.courses[index]['course_id'],
                    state.courses[index]['course_name'],
                    context.read<CoursesBloc>(),
                  ),
                );
              },
            );
          } else if (state is CoursesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesBloc>().add(FetchCourses());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _onCourseTapped(BuildContext context, String courseId, String courseName,
      CoursesBloc coursesBloc) async {
    final token = await StorageService.getToken();
    if (token == null) {
      await StorageService.deleteToken();
      Future.microtask(
          () => Navigator.of(context).pushReplacementNamed(AppRoutes.login));
      return;
    }
    Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoriesPage(
            courseId: courseId,
            courseName: courseName,
            token: token,
            categoriesApiService: coursesBloc.categoriesApiService,
          ),
        ),
      );
    });
  }

  void _logoutAndNavigate(BuildContext context) async {
    await StorageService.deleteToken();
    Future.microtask(
        () => Navigator.of(context).pushReplacementNamed(AppRoutes.login));
  }
}
