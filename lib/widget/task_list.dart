import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/task_detail_page.dart';
import 'package:startup_namer/pages/timer_page.dart';
import 'package:startup_namer/util/navigator_util.dart';
import 'package:startup_namer/widget/show_snack_bar.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';

class TaskList extends StatelessWidget {
  final String title;
  final Future<List<TaskModel>> Function() fetchTask;
  final bool completed;

  const TaskList({
    Key? key,
    required this.title,
    required this.fetchTask,
    required this.completed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: fetchTask(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TaskModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(title),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (data[index].taskStatus == 0) {
                              // If the task is completed but its status is not 1, skip it
                              return const SizedBox.shrink();
                            } else if (data[index].taskStatus == 1) {
                              // If the task is not completed but its status is 1, skip it
                              return const SizedBox.shrink();
                            }

                            return Slidable(
                              endActionPane: data[index].taskStatus == 1
                                  ? ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          label: '删除',
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete_forever,
                                          onPressed: (context) async {
                                            await provider
                                                .deleteTask(data[index].id!);
                                            showSnackBar(
                                              context,
                                              '删除成功',
                                              '撤销',
                                              () =>
                                                  provider.addTask(data[index]),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          label: '开始计时',
                                          backgroundColor: Colors.blue,
                                          icon: Icons.timer_outlined,
                                          onPressed: (context) {
                                            NavigatorUtil.push(
                                              context,
                                              TimerPage(
                                                title: data[index].title,
                                                seconds: data[index].taskTime!,
                                              ),
                                            );
                                          },
                                        ),
                                        SlidableAction(
                                          label: '删除',
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete_forever,
                                          onPressed: (context) async {
                                            await provider
                                                .deleteTask(data[index].id!);
                                            showSnackBar(
                                              context,
                                              '删除成功',
                                              '撤销',
                                              () =>
                                                  provider.addTask(data[index]),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                              startActionPane: data[index].taskStatus == 0
                                  ? ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          label: '完成',
                                          backgroundColor: Colors.green,
                                          icon: Icons.check,
                                          onPressed: (context) async {
                                            await provider.updateTask(
                                              TaskModel(
                                                title: data[index].title,
                                                taskStatus: 1,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : null,
                              child: completed && data[index].taskStatus == 1
                                ? ListTile(
                                leading: Text('${data[index].taskTime}'),
                                title: Text(data[index].title),
                                subtitle: Text(data[index].note.toString()),
                                onTap: () {
                                  NavigatorUtil.push(
                                    context,
                                    TaskDetailPage(
                                      timeValue: data[index].taskTime!,
                                    ),
                                  );
                                },
                              )
                              : ListTile(
                                leading: Text('${data[index].taskTime}'),
                                title: Text(data[index].title),
                                subtitle: Text(data[index].note.toString()),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
