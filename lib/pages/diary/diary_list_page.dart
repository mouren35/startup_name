import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/model/diary_model.dart';
import 'package:startup_namer/pages/diary/diary_edit_page.dart';
import 'package:startup_namer/provider/diary_provider.dart';
import 'package:startup_namer/widget/post/user_avatar.dart';

class DiaryListPage extends StatelessWidget {
  final User user;

  const DiaryListPage({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日记本'),
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
          IconButton(onPressed: () {}, icon: UserAvatar(email: user.email!)),
        ],
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, diaryProvider, child) {
          return diaryProvider.entries.isEmpty
              ? Center(child: Text('暂无日记，请点击右上角添加'))
              : GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: diaryProvider.entries.length,
                  itemBuilder: (context, index) {
                    DiaryEntry entry = diaryProvider.entries[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditScreen(entry: entry)),
                          );
                        },
                        onLongPress: () {
                          _showDeleteDialog(context, entry);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    _getEmotionEmoji(entry.emotion),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                entry.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除日记'),
        content: Text('确定要删除这篇日记吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<DiaryProvider>(context, listen: false)
                  .deleteEntry(entry.id!);
              Navigator.of(context).pop();
            },
            child: Text('删除'),
          ),
        ],
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
