// exercise.dart
import 'package:flutter/material.dart';
import 'api/exercise_api_service.dart';
import 'routes.dart';
import 'storage.dart';

class ExercisePage extends StatefulWidget {
  final String categoryId;

  const ExercisePage({Key? key, required this.categoryId}) : super(key: key);

  @override
  ExercisePageState createState() => ExercisePageState();
}

class ExercisePageState extends State<ExercisePage> {
  final ExerciseApiService _translationExerciseApiService =
      ExerciseApiService();
  final TextEditingController _userInputController = TextEditingController();

  bool _loading = true;
  bool _answerSent = false;
  bool _waitingForResponse = false;
  Map<String, dynamic> _exerciseData = {};
  String? _expectedAnswer;
  bool? _isAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _getExercise();
  }

  Future<void> _getExercise() async {
    setState(() {
      _loading = true;
    });
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        await StorageService.deleteToken();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        final Map<String, dynamic> response =
            await _translationExerciseApiService.getExercise(
                token, widget.categoryId);
        if (!mounted) return;
        setState(() {
          _exerciseData = response;
          _loading = false;
          _answerSent = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _sendAnswer() async {
    setState(() {
      _waitingForResponse = true;
    });
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        await StorageService.deleteToken();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        final userInput = _userInputController.text;
        final response = await _translationExerciseApiService.sendAnswer(
            token, _exerciseData["excercise_id"], userInput);
        if (!mounted) return;
        setState(() {
          _expectedAnswer = response["expected"];
          _isAnswerCorrect = response["answer_result"];
          _answerSent = true;
          _waitingForResponse = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  IconData getAnswerIcon(bool? result) {
    return result == true ? Icons.check : Icons.close;
  }

  Color getAnswerColor(bool? result) {
    return result == true ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final bool userInputEmpty = _userInputController.text.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    _exerciseData['argument']['sentence'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),

                  // User input text field
                  TextField(
                    controller: _userInputController,
                    onChanged: (_) {
                      setState(() {
                        if (_answerSent) {
                          _answerSent = false;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type your answer here',
                    ),
                    minLines: 1,
                    maxLines: 5,
                    enabled: !_answerSent,
                  ),

                  const SizedBox(height: 16.0),

                  if (_answerSent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _waitingForResponse
                            ? const CircularProgressIndicator()
                            : Icon(
                                getAnswerIcon(_isAnswerCorrect),
                                color: getAnswerColor(_isAnswerCorrect),
                              ),
                        Text(_expectedAnswer ?? ''),
                        ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () async {
                                  _userInputController.clear();
                                  await _getExercise();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getAnswerColor(_isAnswerCorrect),
                          ),
                          child: const Text('Continue'),
                        ),
                      ],
                    )
                  else
                    _waitingForResponse
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: userInputEmpty ? null : _sendAnswer,
                            child: const Text('Send answer'),
                          ),
                ],
              ),
            ),
    );
  }
}
