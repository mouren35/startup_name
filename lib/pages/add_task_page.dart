import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/task_db.dart';
import '../model/task_model.dart';
import '../widget/show_toast.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  Duration _duration = const Duration(minutes: 25);

  Color _taskColor = Colors.purple; // 默认任务颜色

  final Map<Color, String> colorMap = {
    Colors.purple: '工作',
    Colors.red: '人际',
    Colors.yellow: '兴趣',
    Colors.green: '健康',
    Colors.blue: '心智',
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加任务'),
        actions: [
          TextButton(
            onPressed: () async {
              final selectedDuration = await _showDurationPickerDialog(context);
              if (selectedDuration != null) {
                setState(() {
                  _duration = selectedDuration;
                });
              }
            },
            child: Text('${_duration.inMinutes} 分钟'),
          ),
          IconButton(
            onPressed: () {
              _addTask(provider);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '任务标题',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: '请输入任务标题',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '任务步骤',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: noteController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: '请输入任务步骤',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '任务备注',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: stepsController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '请输入任务备注',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              // ElevatedButton(
              //   onPressed: () async {
              //     final selectedDuration =
              //         await _showDurationPickerDialog(context);
              //     if (selectedDuration != null) {
              //       setState(() {
              //         _duration = selectedDuration;
              //       });
              //     }
              //   },
              //   child: Text('设置任务时长 (${_duration.inMinutes} 分钟)'),
              // ),
              const Text(
                '选择任务类型',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 7.0,
                children: colorMap.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(entry.value),
                    selectedColor: entry.key,
                    selected: _taskColor == entry.key,
                    onSelected: (selected) {
                      setState(() {
                        _taskColor = entry.key;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Duration?> _showDurationPickerDialog(BuildContext context) async {
    return showDurationPicker(
      context: context,
      initialDuration: _duration,
      confirmText: '确定',
      cancelText: '取消',
    );
  }

  void _addTask(TaskDB provider) {
    final title = titleController.text;
    final note = noteController.text;
    final steps = stepsController.text;
    final id = DateTime.now().millisecondsSinceEpoch;

    if (_duration != Duration.zero) {
      provider.addTask(
        TaskModel(
          id: id,
          title: title,
          note: note,
          steps: steps,
          taskDuration: _duration.inMinutes,
          createdAt: DateTime.now(),
          taskColor: _taskColor, // 添加颜色属性
        ),
      );
      titleController.clear();
      noteController.clear();
      stepsController.clear();
      ShowToast().showToast(
        msg: "添加成功",
        backgroundColor: Colors.green,
      );
    } else {
      ShowToast().showToast(
        msg: "时间不能为0",
        backgroundColor: Colors.red,
      );
    }
    _duration = const Duration(minutes: 25);
  }
}
