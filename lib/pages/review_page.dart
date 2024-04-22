import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import '../widget/reusable_card.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("复习"),
      ),
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

  @override
  Widget build(BuildContext context) {
    final progressValue = _reviewCompleted
        ? 1.0
        : (_currentIndexNumber + 1) / widget.noteList.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _reviewCompleted
              ? "复习完成"
              : "Question ${_currentIndexNumber + 1} of ${widget.noteList.length} Completed",
          style: TextStyle(
            fontSize: 24,
            fontWeight: _reviewCompleted ? FontWeight.bold : FontWeight.normal,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _currentIndexNumber > 0 && !_reviewCompleted
                  ? () {
                      setState(() {
                        _currentIndexNumber--;
                      });
                    }
                  : null,
              icon: const Icon(FontAwesomeIcons.handPointLeft, size: 30),
              label: const Text(""),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    right: 20, left: 25, top: 15, bottom: 15),
              ),
            ),
            ElevatedButton.icon(
              onPressed: !_reviewCompleted
                  ? () {
                      setState(() {
                        if (_currentIndexNumber < widget.noteList.length - 1) {
                          _currentIndexNumber++;
                        } else {
                          _reviewCompleted = true;
                        }
                      });
                    }
                  : null,
              icon: const Icon(FontAwesomeIcons.handPointRight, size: 30),
              label: const Text(""),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    right: 20, left: 25, top: 15, bottom: 15),
              ),
            ),
          ],
        ),
        if (_reviewCompleted)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("退出"),
          ),
      ],
    );
  }
}
