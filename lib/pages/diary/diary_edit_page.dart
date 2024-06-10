import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/diary_model.dart';
import 'package:startup_namer/provider/diary_provider.dart';


class EditScreen extends StatefulWidget {
  final DiaryEntry? entry;

  const EditScreen({super.key, this.entry});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late String _emotion;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _title = widget.entry!.title;
      _content = widget.entry!.content;
      _emotion = widget.entry!.emotion;
    } else {
      _title = '';
      _content = '';
      _emotion = 'Happy'; // Default emotion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Add Entry' : 'Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content'),
                onSaved: (value) {
                  _content = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _emotion,
                decoration: const InputDecoration(labelText: 'Emotion'),
                items: const [
                  DropdownMenuItem(value: 'Happy', child: Text('😊 Happy')),
                  DropdownMenuItem(value: 'Sad', child: Text('😢 Sad')),
                  DropdownMenuItem(value: 'Angry', child: Text('😡 Angry')),
                  DropdownMenuItem(value: 'Neutral', child: Text('😐 Neutral')),
                ],
                onChanged: (value) {
                  setState(() {
                    _emotion = value as String;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an emotion';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    DiaryEntry newEntry = DiaryEntry(
                      id: widget.entry?.id,
                      title: _title,
                      content: _content,
                      date: DateTime.now(),
                      emotion: _emotion,
                    );
                    if (widget.entry == null) {
                      Provider.of<DiaryProvider>(context, listen: false)
                          .addEntry(newEntry);
                    } else {
                      Provider.of<DiaryProvider>(context, listen: false)
                          .updateEntry(newEntry);
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
