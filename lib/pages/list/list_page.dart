// lib/screens/todo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/list/list_detail_page.dart';
import 'package:startup_namer/provider/list_provider.dart';


class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('清单'),
      ),
      body: ListView.builder(
        itemCount: todoProvider.todoLists.length,
        itemBuilder: (context, index) {
          final todoList = todoProvider.todoLists[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoDetailScreen(index: index),
                  ),
                );
              },
            ),
            title: Focus(
              child: TextField(
                controller: TextEditingController(text: todoList.title),
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (newTitle) {
                  todoProvider.updateTodoListTitle(index, newTitle);
                },
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  todoProvider.updateTodoListTitle(index, todoList.title);
                }
              },
            ),
            trailing: Text('${todoList.items.length} 项'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoProvider.addTodoList('新清单');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
