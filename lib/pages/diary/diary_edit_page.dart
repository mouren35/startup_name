import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/diary_model.dart';
import 'package:startup_namer/provider/diary_provider.dart';


class EditScreen extends StatefulWidget {
  final DiaryEntry? entry;

  EditScreen({this.entry});

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

  void _selectEmotion(String emotion) {
    setState(() {
      _emotion = emotion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Add Entry' : 'Edit Entry'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.emoji_emotions),
            onSelected: _selectEmotion,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Happy',
                child: Text('😊 Happy'),
              ),
              PopupMenuItem(
                value: 'Sad',
                child: Text('😢 Sad'),
              ),
              PopupMenuItem(
                value: 'Angry',
                child: Text('😡 Angry'),
              ),
              PopupMenuItem(
                value: 'Neutral',
                child: Text('😐 Neutral'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
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
              SizedBox(height: 16),
              Text('Selected Emotion: ${_getEmotionEmoji(_emotion)} $_emotion'),
              SizedBox(height: 20),
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
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion) {
      case 'Happy':
        return '😊';
      case 'Sad':
        return '😢';
      case 'Angry':
        return '😡';
      case 'Neutral':
        return '😐';
      default:
        return '';
    }
  }
}
