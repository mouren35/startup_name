// lib/screens/todo_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/provider/list_provider.dart';


class TodoDetailScreen extends StatelessWidget {
  final int index;

  const TodoDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todoList = todoProvider.todoLists[index];
    final TextEditingController taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(todoList.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoList.items.length + todoList.subLists.length,
              itemBuilder: (context, itemIndex) {
                if (itemIndex < todoList.subLists.length) {
                  final subList = todoList.subLists[itemIndex];
                  return ListTile(
                    leading: const Icon(Icons.list),
                    title: Text(subList.title),
                    trailing: Text('${subList.items.length} 项'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetailScreen(index: index),
                        ),
                      );
                    },
                  );
                } else {
                  final item =
                      todoList.items[itemIndex - todoList.subLists.length];
                  return ListTile(
                    title: Text(
                      item.content,
                      style: TextStyle(
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Checkbox(
                      value: item.isCompleted,
                      onChanged: (bool? value) {
                        todoProvider.updateTodoItemStatus(index,
                            itemIndex - todoList.subLists.length, value!);
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(hintText: '新任务'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      todoProvider.addTodoItem(index, taskController.text);
                      taskController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: const InputDecoration(hintText: '新子清单'),
                    onSubmitted: (newTitle) {
                      todoProvider.addTodoList(newTitle,
                          parentListId: todoList.id);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    const newTitle = '新子清单';
                    todoProvider.addTodoList(newTitle,
                        parentListId: todoList.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
