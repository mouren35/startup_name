import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/add_note_page.dart';
import 'package:startup_namer/pages/review_page.dart';
import 'package:startup_namer/widget/custom_appbar.dart';

import '../db/note_db.dart';
import '../model/note_model.dart';
import '../util/navigator_util.dart';
import '../widget/show_snack_bar.dart';
import 'note_detail_page.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: const [Icon(Icons.add), Icon(Icons.quiz_outlined)],
        onActionPressed: [
          () {
            NavigatorUtil.push(context, const AddNotePage());
          },
          () {
            NavigatorUtil.push(context, const ReviewPage());
          }
        ],
      ),
      body: Consumer<NoteDb>(
        builder: (context, provider, _) {
          return FutureBuilder<List<NoteModel>?>(
            future: provider.getNote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final data = snapshot.data ?? [];

              if (data.isEmpty) {
                return const Center(
                  child: Text('没有可用的笔记'),
                );
              }

              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final note = data[index];
                  return _buildSlidableNoteItem(context, note);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSlidableNoteItem(BuildContext context, NoteModel note) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: '删除',
            backgroundColor: Colors.red,
            icon: Icons.delete_forever,
            onPressed: (context) async {
              await _deleteNoteAndShowSnackBar(context, note);
            },
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          NavigatorUtil.push(
            context,
            NoteDetailPage(note: note), // 传递NoteModel对象给详情页
          );
        },
        title: Text(note.title),
        subtitle: Text(note.answer),
      ),
    );
  }

  Future<void> _deleteNoteAndShowSnackBar(
      BuildContext context, NoteModel note) async {
    final provider = Provider.of<NoteDb>(context, listen: false);
    await provider.deleteNote(note.id);
    if (context.mounted) {
      showSnackBar(
        context,
        '删除成功',
        '撤销',
        () => provider.addNote(note),
      );
    }
  }
}
