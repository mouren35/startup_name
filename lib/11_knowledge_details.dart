import 'package:flutter/material.dart';
import 'Database/Questions.dart';

class KnowledgeDetails extends StatefulWidget {
  // final Question question;
  KnowledgeDetails({
    Key? key,
    /*required this.question*/
  }) : super(key: key);

  @override
  State<KnowledgeDetails> createState() => _KnowledgeDetailsState();
}

class _KnowledgeDetailsState extends State<KnowledgeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.question.toString()),
          ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Colors.white, Colors.deepOrangeAccent],
          // ),
//              image: DecorationImage(
//                  image: Image.asset("images/editor1.jpg").image,
//                  fit: BoxFit.fill),
        ),
        // child: ZefyrEditor(
        //   controller: _controller,
        //   focusNode: _focusNode,
        //   enabled: _editing,
        //   imageDelegate: new CustomImageDelegate(),
        // ),
      ),
    );
  }
}
