import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exercise_bloc.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';
import '../api/exercise_api_service.dart';
import '../routes.dart';

class ExercisePage extends StatelessWidget {
  final String categoryId;

  const ExercisePage({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(ExerciseApiService())
        ..add(GetExercise(categoryId: categoryId)),
      child: ExerciseView(categoryId: categoryId),
    );
  }
}

class ExerciseView extends StatefulWidget {
  final String categoryId;

  const ExerciseView({Key? key, required this.categoryId}) : super(key: key);

  @override
  ExerciseViewState createState() => ExerciseViewState();
}

class ExerciseViewState extends State<ExerciseView> {
  final TextEditingController _userInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExerciseLoaded) {
            return _buildExerciseContent(context, state.exerciseData);
          } else if (state is ExerciseWaitingForResponse) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnswerSent) {
            return _buildAnswerSentContent(context, state.response);
          } else if (state is ExerciseError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is ExerciseUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            });
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildExerciseContent(
      BuildContext context, Map<String, dynamic> exerciseData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Exercise title
          Text(
            'Переведите предложение',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),

          // Exercise prompt
          SelectableText(
            exerciseData['argument']['sentence'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),

          // User input text field
          TextField(
            controller: _userInputController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Type your answer here',
            ),
            minLines: 1,
            maxLines: 5,
          ),

          const SizedBox(height: 16.0),

          ElevatedButton(
            onPressed: _userInputController.text.isEmpty
                ? null
                : () {
                    BlocProvider.of<ExerciseBloc>(context).add(
                      SendAnswer(
                        exerciseData["excercise_id"],
                        _userInputController.text,
                      ),
                    );
                  },
            child: const Text('Send answer'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSentContent(
      BuildContext context, Map<String, dynamic> response) {
    bool? isAnswerCorrect = response["answer_result"];
    String? expectedAnswer = response["expected"];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Exercise title
          Text(
            'Переведите предложение',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),

          // Exercise prompt
          SelectableText(
            response['argument']['sentence'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),

          // User input text field
          TextField(
            controller: _userInputController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Type your answer here',
            ),
            minLines: 1,
            maxLines: 5,
            enabled: false,
          ),

          const SizedBox(height: 16.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                isAnswerCorrect == true ? Icons.check : Icons.close,
                color: isAnswerCorrect == true ? Colors.green : Colors.red,
              ),
              Text(expectedAnswer ?? ''),
              ElevatedButton(
                onPressed: () {
                  _userInputController.clear();
                  BlocProvider.of<ExerciseBloc>(context).add(
                    GetExercise(categoryId: widget.categoryId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isAnswerCorrect == true ? Colors.green : Colors.red,
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExerciseBloc>(context).add(
      GetExercise(categoryId: widget.categoryId),
    );
  }

  @override
  void dispose() {
    _userInputController.dispose();
    super.dispose();
  }
}
