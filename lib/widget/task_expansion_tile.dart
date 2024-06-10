import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import '../pages/task_detail_page.dart';
import '../pages/timer_page.dart';
import '../util/navigator_util.dart';
import 'show_snack_bar.dart';

class TaskExpansionTile extends StatelessWidget {
  final String title;
  final List<TaskModel> tasks;

  const TaskExpansionTile({
    Key? key,
    required this.title,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(title),
      children: [
        ListView.builder(
          itemCount: tasks.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final task = tasks[index];
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: task.taskColor.withOpacity(0.3), // 使用颜色属性
                border: Border.all(
                  color: task.taskColor, // 使用颜色属性
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    if (title == '未完成') ...[
                      SlidableAction(
                        label: '计时',
                        backgroundColor: Colors.blue,
                        icon: Icons.timer_outlined,
                        onPressed: (context) {
                          NavigatorUtil.push(
                              context,
                              TimerPage(
                                id: task.id!,
                                title: task.title,
                                seconds: task.taskDuration!,
                                note: task.note ?? '没有内容',
                                step: task.steps ?? '没有内容',
                              ));
                        },
                      ),
                    ],
                    SlidableAction(
                      label: '删除',
                      backgroundColor: Colors.red,
                      icon: Icons.delete_forever,
                      onPressed: (context) async {
                        await provider.deleteTask(task.id!);
                        if (context.mounted) {
                          showSnackBar(
                            context,
                            '删除成功',
                            '撤销',
                            () => provider.addTask(task),
                          );
                        }
                      },
                    ),
                  ],
                ),
                startActionPane: title == '未完成'
                    ? ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: '完成',
                            backgroundColor: Colors.green,
                            icon: Icons.check,
                            onPressed: (context) async {
                              await provider.updateTask(task.id!, 1);
                            },
                          ),
                        ],
                      )
                    : null,
                child: ListTile(
                  leading: Text('${task.taskDuration}'),
                  title: Text(task.title),
                  subtitle: Text(task.note.toString()),
                  onTap: () {
                    NavigatorUtil.push(
                      context,
                      TaskDetailPage(
                        title: task.title,
                        time: task.taskDuration!,
                        step: task.steps ?? '',
                        note: task.note ?? '',
                        id: task.id,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
