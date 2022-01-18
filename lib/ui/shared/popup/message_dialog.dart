import 'package:flutter/material.dart';
import 'custom_dialog.dart';

class MessageDialog extends StatelessWidget {
  final String? title;
  final String message;

  MessageDialog({this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      primaryButton: PrimaryDialogButton(
        text: 'OK',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
