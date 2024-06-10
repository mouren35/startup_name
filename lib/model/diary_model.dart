class DiaryEntry {
  int? id;
  String title;
  String content;
  DateTime date;
  String emotion;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.emotion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'emotion': emotion,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      emotion: map['emotion'],
    );
  }
}
