import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/diary_model.dart';
import 'package:startup_namer/pages/diary/diary_edit_page.dart';
import 'package:startup_namer/provider/diary_provider.dart';


class DiaryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditScreen(entry: null)),
              );
            },
          ),
        ],
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, diaryProvider, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 两列网格
              childAspectRatio: 3 / 2, // 调整比例以适应内容
            ),
            itemCount: diaryProvider.entries.length,
            itemBuilder: (context, index) {
              DiaryEntry entry = diaryProvider.entries[index];
              return Card(
                elevation: 2,
                child: GridTile(
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(entry.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  child: Center(
                      child: Text(
                          '${getEmotionEmoji(entry.emotion)} ${entry.emotion}')),
                  footer: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditScreen(entry: entry)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<DiaryProvider>(context, listen: false)
                              .deleteEntry(entry.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getEmotionEmoji(String emotion) {
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
