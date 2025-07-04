class NoteModel {
  final int id;
  final String title;
  final String answer;
  final String idField;
  final String titleField;
  final String answerField;

  NoteModel({
    required this.id,
    required this.title,
    required this.answer,
    this.idField = 'id',
    this.titleField = 'title',
    this.answerField = 'answer',
  });

  NoteModel.fromMap(
    Map<String, dynamic> res, {
    this.idField = 'id',
    this.titleField = 'title',
    this.answerField = 'answer',
  })  : id = res[idField],
        title = res[titleField],
        answer = res[answerField];

  Map<String, Object?> toMap() {
    return {
      idField: id,
      titleField: title,
      answerField: answer,
    };
  }
}
