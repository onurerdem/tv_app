import 'package:flutter/material.dart';

Future<bool?> showWatchedDialog(
    BuildContext context, String title, String content) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      icon: Icon(Icons.warning, color: Colors.red),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('No'),
          onPressed: () => Navigator.of(ctx).pop(false),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Yes'),
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ],
    ),
  );
}
