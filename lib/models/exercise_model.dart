class Exercise {
  final String id;
  final String sentence;

  Exercise({required this.id, required this.sentence});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['excercise_id'],
      sentence: json['argument']['sentence'],
    );
  }
}
