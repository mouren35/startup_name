import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message,
  String label,
  VoidCallback onUndo,
) {
  final snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: '撤销',
      onPressed: onUndo,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
