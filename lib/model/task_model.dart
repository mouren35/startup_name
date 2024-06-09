import '../db/task_db.dart';

class TaskModel {
  final int? id;
  final String title;
  final String? note;
  final String? steps;
  final int? taskDuration;
  final int taskStatus;

  TaskModel({
    this.id,
    required this.title,
    this.note,
    this.steps,
    this.taskDuration = 25,
    this.taskStatus = 0,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        note = res['note'],
        steps = res['steps'],
        taskDuration = res['time'], //列名不要搞错了
        taskStatus = res['taskStatus'];

  Map<String, Object?> toMap() {
    return {
      TaskDB.id: id,
      TaskDB.title: title,
      TaskDB.note: note,
      TaskDB.steps: steps,
      TaskDB.taskDuration: taskDuration,
      TaskDB.taskStatus: taskStatus,
    };
  }
}
