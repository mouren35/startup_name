import 'package:flutter/material.dart';
import 'package:startup_namer/db/habit_db.dart';
import 'package:startup_namer/model/habit_model.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  Future<void> loadHabits() async {
    _habits = await DatabaseService().habits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await DatabaseService().insertHabit(habit);
    await loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await DatabaseService().updateHabit(habit);
    await loadHabits();
  }

  Future<void> deleteHabit(int id) async {
    await DatabaseService().deleteHabit(id);
    await loadHabits();
  }
}
