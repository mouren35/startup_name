import '../db/note_db.dart';

class NoteModel {
  final int? id;
  final String title;
  final String answer;

  NoteModel({
    this.id,
    required this.title,
    required this.answer,
  });

  NoteModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        answer = res["answer"];

  Map<String, Object?> toMap() {
    return {
      NoteDb.columnId: id,
      NoteDb.columnTitle: title,
      NoteDb.columnAnswer: answer,
    };
  }
}
