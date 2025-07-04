import 'package:flutter/material.dart';
import '../services/task_db.dart';

class TaskModel {
  final int? id;
  final String title;
  final String? note;
  final String? steps;
  final int? taskDuration;
  final int taskStatus;
  final DateTime createdAt;
  final Color taskColor; // 新增颜色属性
  final String repeatType; // 添加重复类型属性
  final int repeatInterval; // 添加重复周期属性
  final int? listId; // 新增清单ID属性

  TaskModel({
    this.id,
    required this.title,
    this.note,
    this.steps,
    this.taskDuration = 25,
    this.taskStatus = 0,
    required this.createdAt,
    required this.taskColor, // 更新构造函数
    required this.repeatType, // 初始化重复类型
    required this.repeatInterval, // 初始化重复周期
    this.listId,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        note = res['note'],
        steps = res['steps'],
        taskDuration = res['time'],
        taskStatus = res['taskStatus'],
        createdAt = DateTime.parse(res['createdAt']),
        taskColor = Color(res['taskColor']), // 从Map中读取颜色
        repeatType = res['repeatType'], // 解析重复类型
        repeatInterval = res['repeatInterval'], // 解析重复周期
        listId = res['listId']; // 解析清单ID

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
      TaskDB.repeatType: repeatType, // 存储重复类型
      TaskDB.repeatInterval: repeatInterval, // 存储重复周期
      TaskDB.listId: listId, // 添加清单ID
    };
  }
}
