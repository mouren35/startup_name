// lib/providers/todo_provider.dart
import 'package:flutter/material.dart';
import 'package:startup_namer/db/list_db.dart';
import 'package:startup_namer/model/list_model.dart';


class TodoProvider with ChangeNotifier {
  List<TodoList> _todoLists = [];

  List<TodoList> get todoLists => _todoLists;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  TodoProvider() {
    _loadTodoLists();
  }

  Future<void> _loadTodoLists() async {
    _todoLists = await _dbHelper.getTodoLists();
    for (var list in _todoLists) {
      list.items = await _dbHelper.getTodoItems(list.id!);
      list.subLists = await _dbHelper.getTodoLists(parentListId: list.id);
    }
    notifyListeners();
  }

  Future<void> addTodoList(String title, {int? parentListId}) async {
    TodoList newList = TodoList(
        title: title, items: [], subLists: [], parentListId: parentListId);
    await _dbHelper.insertTodoList(newList);
    await _loadTodoLists();
  }

  Future<void> addTodoItem(int listIndex, String content) async {
    TodoItem newItem =
        TodoItem(listId: _todoLists[listIndex].id!, content: content);
    await _dbHelper.insertTodoItem(newItem);
    await _loadTodoLists();
  }

  Future<void> updateTodoListTitle(int index, String newTitle) async {
    _todoLists[index].title = newTitle;
    await _dbHelper.insertTodoList(_todoLists[index]);
    notifyListeners();
  }

  Future<void> updateTodoItemStatus(
      int listIndex, int itemIndex, bool isCompleted) async {
    _todoLists[listIndex].items[itemIndex].isCompleted = isCompleted;
    await _dbHelper.updateTodoItem(_todoLists[listIndex].items[itemIndex]);
    notifyListeners();
  }
}
