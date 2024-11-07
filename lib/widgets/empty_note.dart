import 'package:flutter/material.dart';

class EmptyNote extends StatelessWidget {
  const EmptyNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/gummy-notebook.png',
            width: MediaQuery.sizeOf(context).width * 0.7,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'No notes,\nadd notes by pressing the + button in the bottom right.\n',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
