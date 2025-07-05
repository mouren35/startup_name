import "package:startup_namer/core/constants.dart";
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../services/task_db.dart';
import '../models/task_model.dart';
import '../pages/task/task_detail_page.dart';
import '../pages/task/timer_page.dart';
import '../utils/navigator_util.dart';
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
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      children: [
        ListView.builder(
          itemCount: tasks.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final task = tasks[index];
            return Card(
              elevation: 2,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                side: BorderSide(color: task.taskColor, width: 1),
              ),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    if (title == '未完成') ...[
                      SlidableAction(
                        label: '计时',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
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
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
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
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            icon: Icons.check,
                            onPressed: (context) async {
                              await provider.updateTask(task.id!, 1);
                            },
                          ),
                        ],
                      )
                    : null,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Chip(
                    label: Text('${task.taskDuration} min'),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    task.note.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    NavigatorUtil.push(
                      context,
                      TaskDetailPage(
                        title: task.title,
                        time: task.taskDuration!,
                        step: task.steps ?? '',
                        note: task.note ?? '',
                        id: task.id,
                        task: task,
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
