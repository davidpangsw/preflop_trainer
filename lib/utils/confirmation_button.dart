import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget {
  final Text buttonText;
  final String dialogTitle;
  final String dialogContent;
  final VoidCallback onConfirm;

  const ConfirmationButton({
    super.key,
    required this.buttonText,
    this.dialogTitle = 'Confirm Action',
    this.dialogContent = 'Are you sure you want to proceed?',
    required this.onConfirm,
  });

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showConfirmationDialog(context),
      child: buttonText,
    );
  }
}