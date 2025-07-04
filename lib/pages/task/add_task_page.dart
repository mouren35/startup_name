import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/task_db.dart';
import '../../model/task_model.dart';
import '../../widget/show_toast.dart';

class AddTaskPage extends StatefulWidget {
  final TaskModel? task; // 添加任务模型参数，用于编辑
  const AddTaskPage({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  Duration _duration = const Duration(minutes: 25);

  Color _taskColor = Colors.purple; // 默认任务颜色
  String _repeatType = '不重复'; // 默认重复类型
  int _repeatInterval = 1; // 默认重复周期
  int? _selectedListId; // 新增：选中的清单ID

  final Map<Color, String> colorMap = {
    Colors.purple: '工作',
    Colors.red: '人际',
    Colors.yellow: '兴趣',
    Colors.green: '健康',
    Colors.blue: '心智',
  };

  final List<String> repeatTypes = ['不重复', '按天', '按周', '按月'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      noteController.text = widget.task!.note ?? '';
      stepsController.text = widget.task!.steps ?? '';
      _duration = Duration(minutes: widget.task!.taskDuration ?? 25);
      _taskColor = widget.task!.taskColor;
      _repeatType = widget.task!.repeatType;
      _repeatInterval = widget.task!.repeatInterval;
      _selectedListId = widget.task!.listId; // 初始化选中的清单ID
    }
  }

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
              const SizedBox(height: 16.0),
              const Text(
                '选择重复周期',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _repeatType,
                items: repeatTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _repeatType = newValue!;
                  });
                },
              ),
              if (_repeatType != '不重复')
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '重复周期间隔（天/周/月）',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _repeatInterval = int.parse(value);
                    });
                  },
                ),
              const SizedBox(height: 16.0),
              const Text(
                '选择清单',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              FutureBuilder<List<Map<String, Object?>>?>(
                future: provider.getLists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('没有可用的清单');
                  }

                  return DropdownButton<int>(
                    value: _selectedListId,
                    items: snapshot.data!.map((list) {
                      return DropdownMenuItem<int>(
                        value: list['id'] as int?,
                        child: Text(list['title'] as String),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedListId = newValue;
                      });
                    },
                    hint: const Text('选择清单'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Duration?> _showDurationPickerDialog(BuildContext context) async {
    return await showDurationPicker(
      context: context,
      initialTime: Duration(minutes: 0),
    );
  }

  void _addTask(TaskDB provider) {
    if (titleController.text.isEmpty) {
      ShowToast().showToast(msg: '任务标题不能为空', backgroundColor: Colors.red);
      return;
    }
    final title = titleController.text;
    final note = noteController.text;
    final steps = stepsController.text;
    final id = widget.task?.id ?? DateTime.now().millisecondsSinceEpoch;

    final task = TaskModel(
      id: id,
      title: title,
      note: note,
      steps: steps,
      taskDuration: _duration.inMinutes,
      createdAt: DateTime.now(),
      taskColor: _taskColor, // 添加颜色属性
      repeatType: _repeatType,
      repeatInterval: _repeatInterval,
      listId: _selectedListId,
    );
    if (widget.task != null) {
      provider.updateTaskDetails(task);
      ShowToast().showToast(
        msg: "修改成功",
        backgroundColor: Colors.green,
      );
    } else {
      if (_duration != Duration.zero) {
        provider.addTask(task);
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
    }

    _duration = const Duration(minutes: 25);
    Navigator.of(context).pop();
  }
}
