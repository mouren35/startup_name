import 'QuestionHelper.dart';

class Question {
  final int? id;
  final String title;
  final String answer;

  Question({
    this.id,
    required this.title,
    required this.answer,
  });

  Question.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        answer = res["answer"];

  Map<String, Object?> toMap() {
    return {
      DatabaseHandler.columnId: id,
      DatabaseHandler.columnTitle: title,
      DatabaseHandler.columnAnswer: answer,
    };
  }
}
