import 'package:flutter/cupertino.dart';

import '../model/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  void addTaskModel(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTaskModel(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTaskModel(TaskModel task) {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void toggleTaskModelStatus(TaskModel task) {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    if (index >= 0) {
      _tasks[index].taskStatus = task.taskStatus;
      notifyListeners();
    }
  }

  void clearCompletedTaskModels() {
    _tasks.removeWhere((element) => element.taskStatus == 1);
    notifyListeners();
  }

  void clearAllTaskModels() {
    _tasks.clear();
    notifyListeners();
  }
}
