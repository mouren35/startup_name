import '../db/task_db.dart';

class TaskModel {
  final int? id;
  final String title;
  final String? note;
  final String? steps;
  final int? taskDuration;
  final int taskStatus;
  final DateTime createdAt;

  TaskModel({
    this.id,
    required this.title,
    this.note,
    this.steps,
    this.taskDuration = 25,
    this.taskStatus = 0,
    required this.createdAt,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        note = res['note'],
        steps = res['steps'],
        taskDuration = res['time'],
        taskStatus = res['taskStatus'],
        createdAt = DateTime.parse(res['createdAt']);

  Map<String, Object?> toMap() {
    return {
      TaskDB.id: id,
      TaskDB.title: title,
      TaskDB.note: note,
      TaskDB.steps: steps,
      TaskDB.taskDuration: taskDuration,
      TaskDB.taskStatus: taskStatus,
      TaskDB.createdAt: createdAt.toIso8601String(),
    };
  }
}
