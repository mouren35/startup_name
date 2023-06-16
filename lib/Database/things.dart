import 'things_helper.dart';

class Things {
  final int? id;
  final String title;
  final String note;
  final String steps;
  final String taskTime;
  int? taskStatus;

  Things({
    this.id,
    required this.title,
    required this.note,
    required this.steps,
    required this.taskTime,
    this.taskStatus = 0,
  });

  Things.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        note = res['note'],
        steps = res['steps'],
        taskTime = res['time'], //列名不要搞错了
        taskStatus = res['taskStatus'];

  Map<String, Object?> toMap() {
    return {
      ThingsHandler.columnId: id,
      ThingsHandler.columnTitle: title,
      ThingsHandler.columnNote: note,
      ThingsHandler.columnSteps: steps,
      ThingsHandler.columnTasktime: taskTime,
      ThingsHandler.columnTaskStatus: taskStatus,
    };
  }
}
