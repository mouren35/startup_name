import '../db/task_db.dart';
import 'package:flutter/material.dart';

class TaskModel {
  final int? id;
  final String title;
  final String? note;
  final String? steps;
  final int? taskDuration;
  final int taskStatus;
  final DateTime createdAt;
  final Color taskColor; // 新增颜色属性

  TaskModel({
    this.id,
    required this.title,
    this.note,
    this.steps,
    this.taskDuration = 25,
    this.taskStatus = 0,
    required this.createdAt,
    required this.taskColor, // 更新构造函数
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        note = res['note'],
        steps = res['steps'],
        taskDuration = res['time'],
        taskStatus = res['taskStatus'],
        createdAt = DateTime.parse(res['createdAt']),
        taskColor = Color(res['taskColor']); // 从Map中读取颜色

  Map<String, Object?> toMap() {
    return {
      TaskDB.id: id,
      TaskDB.title: title,
      TaskDB.note: note,
      TaskDB.steps: steps,
      TaskDB.taskDuration: taskDuration,
      TaskDB.taskStatus: taskStatus,
      TaskDB.createdAt: createdAt.toIso8601String(),
      TaskDB.taskColor: taskColor.value, // 存储颜色值
    };
  }
}
