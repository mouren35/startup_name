// lib/models/todo_model.dart
class TodoList {
  int? id;
  int? parentListId; // 添加父清单ID
  String title;
  List<TodoItem> items;
  List<TodoList> subLists; // 添加子清单列表

  TodoList(
      {this.id,
      this.parentListId,
      required this.title,
      required this.items,
      required this.subLists});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentListId': parentListId,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'TodoList{id: $id, parentListId: $parentListId, title: $title}';
  }
}

class TodoItem {
  int? id;
  int listId;
  String content;
  bool isCompleted;

  TodoItem(
      {this.id,
      required this.listId,
      required this.content,
      this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'content': content,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'TodoItem{id: $id, listId: $listId, content: $content, isCompleted: $isCompleted}';
  }
}
