import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_but_better/constants/constants.dart';

class NoteSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;

  const NoteSearchBar({
    Key? key,
    required this.searchController,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(fontSize: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: gray700)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: gray700)),
        fillColor: white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(16),
        prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
        prefixIcon: Icon(
          FontAwesomeIcons.magnifyingGlass,
          size: 16,
        ),
      ),
    );
  }
}
