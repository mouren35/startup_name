import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/pages/post/create_post_screen.dart';
import 'package:startup_namer/provider/post_provider.dart';
import 'package:startup_namer/widget/custom_appbar.dart';
import 'package:startup_namer/widget/post/post_widget.dart';
// 确保导入创建帖子的页面

class PostMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        actions: [Icon(Icons.add)],
        onActionPressed: [
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostScreen(),
              ),
            );
          },
        ],
      ),
      body: ListView.builder(
        itemCount: postProvider.posts.length,
        itemBuilder: (ctx, index) {
          return PostWidget(postProvider.posts[index]);
        },
      ),
    );
  }
}
