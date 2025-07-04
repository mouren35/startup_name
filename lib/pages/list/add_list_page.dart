import "package:startup_namer/core/constants.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/services/task_db.dart';

class AddListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AddListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskDB>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加清单'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '清单名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _controller.text;
                if (title.isNotEmpty) {
                  provider.addList(title);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('添加清单'),
            ),
          ],
        ),
      ),
    );
  }
}
