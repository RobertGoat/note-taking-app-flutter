import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_but_better/constants/constants.dart';

class NoteFloatingActionBtn extends StatelessWidget {
  const NoteFloatingActionBtn({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: onPressed,
      backgroundColor: maincolor,
      foregroundColor: white,
      child: FaIcon(FontAwesomeIcons.plus),
    );
  }
}
