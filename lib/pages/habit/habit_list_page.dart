import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/habit_model.dart';
import 'package:startup_namer/pages/habit/add_habit_page.dart';
import 'package:startup_namer/provider/habit_provider.dart';

class HabitListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddHabitScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return ListView.builder(
            itemCount: habitProvider.habits.length,
            itemBuilder: (context, index) {
              final habit = habitProvider.habits[index];
              return ListTile(
                title: Text(habit.name),
                subtitle: Text(habit.description),
                trailing: Checkbox(
                  value: habit.completed,
                  onChanged: (value) {
                    habitProvider.updateHabit(Habit(
                      id: habit.id,
                      name: habit.name,
                      description: habit.description,
                      frequency: habit.frequency,
                      completed: value!,
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
