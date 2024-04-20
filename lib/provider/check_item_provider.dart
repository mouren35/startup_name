import 'package:flutter/material.dart';

class CheckItem {
  bool isChecked;
  String text;

  CheckItem({required this.isChecked, required this.text});
}

class CheckItemProvider extends ChangeNotifier {
  List<CheckItem> items = [];

  void addItem(CheckItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }
}
