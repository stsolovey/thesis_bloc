class Course {
  final String courseId;

  final String courseName;

  final String fromLanguage;

  final String learningLanguage;

  Course({
    required this.courseId,
    required this.courseName,
    required this.fromLanguage,
    required this.learningLanguage,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseName: json['course_name'],
      fromLanguage: json['from_language'],
      learningLanguage: json['learning_language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_name': courseName,
      'from_language': fromLanguage,
      'learning_language': learningLanguage,
    };
  }
}
