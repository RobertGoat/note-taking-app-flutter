import 'package:flutter/material.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unsaved Changes'),
      content: const Text(
          'You have unsaved changes. Do you want to leave without saving?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Stay on the page
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Leave the page
          },
          child: const Text('Leave'),
        ),
      ],
    );
  }
}
