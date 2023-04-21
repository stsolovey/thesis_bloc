import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_block/api/categories_api_service.dart';
import '../exercise.dart';
import '../routes.dart';
import 'categories_bloc.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String token;
  final CategoriesApiService categoriesApiService;

  const CategoriesPage({
    Key? key,
    required this.courseId,
    required this.courseName,
    required this.token,
    required this.categoriesApiService,
  }) : super(key: key);

  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  late CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    _categoriesBloc =
        CategoriesBloc(categoriesApiService: widget.categoriesApiService);
    _categoriesBloc.add(FetchCategories(widget.courseId, widget.token));
  }

  @override
  void dispose() {
    _categoriesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _categoriesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.courseName),
        ),
        body: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoriesLoaded) {
              return ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.categories[index]['category_name']),
                    onTap: () => _onCategoryTapped(
                        context, state.categories[index]['category_id']),
                  );
                },
              );
            } else if (state is CategoriesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CategoriesBloc>().add(
                            FetchCategories(widget.courseId, widget.token));
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
      ),
    );
  }

  void _onCategoryTapped(BuildContext context, String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(
          categoryId: categoryId,
        ),
      ),
    );
  }
}
