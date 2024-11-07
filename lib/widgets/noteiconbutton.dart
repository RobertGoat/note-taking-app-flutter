import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_but_better/constants/constants.dart';

class NoteIconButton extends StatelessWidget {
  const NoteIconButton(
      {super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        // margin: EdgeInsets.all(8),
        child: FaIcon(
          icon,
          color: white,
        ),
      ),
      style: IconButton.styleFrom(
          backgroundColor: maincolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
    );
  }
}
