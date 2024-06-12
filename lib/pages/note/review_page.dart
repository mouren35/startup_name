import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../db/note_db.dart';
import '../../model/note_model.dart';
import '../../widget/reusable_card.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NoteDb>(
        builder: (context, noteDb, _) {
          return FutureBuilder<List<NoteModel>?>(
            future: noteDb.getNote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final noteList = snapshot.data ?? [];

              return ReviewCards(noteList: noteList);
            },
          );
        },
      ),
    );
  }
}

class ReviewCards extends StatefulWidget {
  final List<NoteModel> noteList;

  const ReviewCards({Key? key, required this.noteList}) : super(key: key);

  @override
  State<ReviewCards> createState() => _ReviewCardsState();
}

class _ReviewCardsState extends State<ReviewCards> {
  int _currentIndexNumber = 0;
  bool _reviewCompleted = false;
  int _score = 0;
  late Timer _timer;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("时间到"),
        content: const Text("你已用完时间，进入下一个问题"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _nextQuestion();
            },
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (_currentIndexNumber < widget.noteList.length - 1) {
      setState(() {
        _currentIndexNumber++;
        _remainingSeconds = 60;
      });
    } else {
      setState(() {
        _reviewCompleted = true;
      });
    }
  }

  Future<void> _showAnswerDialog() async {
    final isCorrect = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("回答情况"),
        content: const Text("你答对了吗？"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("否"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("是"),
          ),
        ],
      ),
    );

    if (isCorrect == true) {
      setState(() {
        _score += 10;
      });
    }

    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = _reviewCompleted
        ? 1.0
        : (_currentIndexNumber + 1) / widget.noteList.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("复习"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '$_remainingSeconds 秒',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _reviewCompleted
                ? "复习完成，得分：$_score"
                : "问题 ${_currentIndexNumber + 1} / ${widget.noteList.length}",
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  _reviewCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: progressValue,
            ),
          ),
          const SizedBox(height: 25),
          if (!_reviewCompleted)
            SizedBox(
              width: 300,
              height: 300,
              child: FlipCard(
                front: ReusableCard(
                    text: widget.noteList[_currentIndexNumber].title),
                back: ReusableCard(
                    text: widget.noteList[_currentIndexNumber].answer),
              ),
            ),
          const SizedBox(height: 20),
          if (!_reviewCompleted)
            ElevatedButton.icon(
              onPressed: () async {
                _timer.cancel();
                await _showAnswerDialog();
                if (!_reviewCompleted) {
                  _startTimer();
                }
              },
              icon: const Icon(FontAwesomeIcons.handPointRight, size: 30),
              label: const Text("回答"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    right: 20, left: 25, top: 15, bottom: 15),
              ),
            ),
          if (_reviewCompleted)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("退出"),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
