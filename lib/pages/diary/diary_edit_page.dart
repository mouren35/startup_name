import "package:startup_namer/core/constants.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/models/diary_model.dart';
import 'package:startup_namer/providers/diary_provider.dart';


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
      _emotion = '快乐'; // 默认心情
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
        title: Text(widget.entry == null ? '添加日记' : '编辑日记'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.emoji_emotions),
            onSelected: _selectEmotion,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: '快乐',
                child: Text('😊 快乐'),
              ),
              const PopupMenuItem(
                value: '悲伤',
                child: Text('😢 悲伤'),
              ),
              const PopupMenuItem(
                value: '愤怒',
                child: Text('😡 愤怒'),
              ),
              const PopupMenuItem(
                value: '平静',
                child: Text('😐 平静'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: '标题',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(
                  labelText: '内容',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) {
                  _content = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入内容';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('选择的心情: ${_getEmotionEmoji(_emotion)} $_emotion'),
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion) {
      case '快乐':
        return '😊';
      case '悲伤':
        return '😢';
      case '愤怒':
        return '😡';
      case '平静':
        return '😐';
      default:
        return '';
    }
  }
}
