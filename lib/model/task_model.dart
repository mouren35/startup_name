import '../db/task_db.dart';

class TaskModel {
  final int? id;
  final String title;
  final String note;
  final String steps;
  final String taskTime;
  int? taskStatus;

  TaskModel({
    this.id,
    required this.title,
    required this.note,
    required this.steps,
    required this.taskTime,
    this.taskStatus = 0,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        note = res['note'],
        steps = res['steps'],
        taskTime = res['time'], //列名不要搞错了
        taskStatus = res['taskStatus'];

  Map<String, Object?> toMap() {
    return {
      TaskDB.columnId: id,
      TaskDB.columnTitle: title,
      TaskDB.columnNote: note,
      TaskDB.columnSteps: steps,
      TaskDB.columnTasktime: taskTime,
      TaskDB.columnTaskStatus: taskStatus,
    };
  }
}
