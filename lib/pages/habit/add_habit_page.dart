import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/habit_model.dart';
import 'package:startup_namer/provider/habit_provider.dart';


class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _frequency = 'daily';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newHabit = Habit(
        id: 0, // The ID will be auto-incremented by the database
        name: _name,
        description: _description,
        frequency: _frequency,
        completed: false,
      );
      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Habit Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Frequency'),
                value: _frequency,
                items: ['daily', 'weekly'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _frequency = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
