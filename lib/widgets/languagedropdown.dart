// language_dropdown.dart
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String selectedLanguage;
  final List<Map<String, String>> languages;
  final Function(String?) onChanged;
  final String hintText;

  const LanguageDropdown({
    required this.selectedLanguage,
    required this.languages,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      items: languages.map((language) {
        return DropdownMenuItem<String>(
          value: language['code'],
          child: Text(
            language['name']!,
            // style: TextStyle(fontSize: 8),
          ),
          //   style: TextStyle(fontSize: 14), // Adjust font size here
          // overflow: TextOverflow.ellipsis,
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text(hintText),
    );
  }
}
