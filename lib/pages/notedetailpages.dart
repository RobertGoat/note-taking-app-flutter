// notedetailpages.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_but_better/change_notifiers/speechtranslatehelper.dart';
import 'package:notes_but_better/constants/constants.dart';
import 'package:notes_but_better/widgets/languagedropdown.dart';
import 'package:notes_but_better/widgets/noteiconbutton.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/notes_provider.dart';
import '../models/note.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class Notedetailpages extends StatefulWidget {
  const Notedetailpages({super.key, required this.isNew, this.note});

  final bool isNew;
  final Note? note;

  @override
  State<Notedetailpages> createState() => _NotedetailpagesState();
}

class _NotedetailpagesState extends State<Notedetailpages> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _originalTitle = '';
  String _originalContent = '';
  bool _canSaveNote = false;
  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Initialize SpeechToText instance

  bool _isListening = false;

  bool _isMicOn = false; // Track microphone state

  final SpeechTranslationHelper _speechHelper = SpeechTranslationHelper();

  String _spokenText = '';
  String _translatedText = '';
  String _inputLanguage = 'en';
  String _targetLanguage = 'es';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'id', 'name': 'Indonesian'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'zh-CN', 'name': 'Chinese (Simplified)'},
    {'code': 'zh-TW', 'name': 'Chinese (Traditional)'},
    // Add more languages as needed
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _originalTitle = widget.note!.title ?? '';
      _originalContent = widget.note!.content ?? '';
      _titleController.text = _originalTitle;
      _contentController.text = _originalContent;
    }

    _titleController.addListener(_updateSaveButtonState);
    _contentController.addListener(_updateSaveButtonState);
  }

  void _saveNote() async {
    final String newTitle = _titleController.text.trim();
    final String newContent = _contentController.text.trim();
    final int now = DateTime.now().microsecondsSinceEpoch;

    final noteData = {
      'title': newTitle.isNotEmpty ? newTitle : null,
      'content': newContent.isNotEmpty ? newContent : null,
      'dateCreated': widget.isNew ? now : widget.note?.dateCreated,
      'dateModified': now,
    };

    if (widget.isNew) {
      // Add a new document to Firestore
      await FirebaseFirestore.instance.collection('notes').add(noteData);
    } else {
      // Update an existing document
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.note
              ?.id) // Make sure to save the document ID when retrieving notes
          .update(noteData);
    }

    Navigator.pop(context);
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('onStatus: $status');
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isMicOn = false; // Update icon if mic stops unexpectedly
          });
        }
      },
      onError: (val) {
        print('onError: $val');
        setState(() {
          _isMicOn = false; // Reset mic state on error
        });
      },
    );

    if (available) {
      setState(() => _isMicOn = true); // Show mic is on
      _speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            setState(() {
              _spokenText = result.recognizedWords;
            });

            // Use the selected language codes in translation
            String translatedText = await _speechHelper.translateText(
              _spokenText,
              _inputLanguage,
              _targetLanguage,
            );

            setState(() {
              _translatedText = translatedText;
              _contentController.text += '\n$_translatedText';
            });
          }
        },
        listenFor: null,
        pauseFor: Duration(seconds: 10),
        partialResults: true,
        localeId: _inputLanguage, // Use selected input language for recognition
      );
    } else {
      print('Speech recognition not available');
    }
  }

  void _toggleMic() {
    if (_isMicOn) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isMicOn = false); // Reset mic state
  }

  @override
  void dispose() {
    _speech.stop(); // Ensure the mic is stopped if the widget is disposed
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(() {
      _canSaveNote = _titleController.text.trim().isNotEmpty ||
          _contentController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NoteIconButton(
            icon: FontAwesomeIcons.arrowLeft,
            onPressed: () {
              // Check if changes were made
              if (_titleController.text != _originalTitle ||
                  _contentController.text != _originalContent) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Unsaved Changes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: maincolor,
                          )),
                      content: Text(
                        "You have unsaved changes. Are you sure you want to go back without saving?",
                        style: TextStyle(
                          color: gray700,
                        ),
                      ),
                      backgroundColor:
                          Colors.white, // Customize background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                      ),
                      actionsPadding: EdgeInsets.only(bottom: 8, right: 16),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: gray700), // Customize button color
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog before going back
                            Navigator.pop(
                                context); // Go back to the previous screen
                          },
                          child: Text(
                            "Discard",
                            style: TextStyle(
                                color: maincolor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // If no changes were made, go back without showing the dialog
                Navigator.pop(context);
              }
            },
          ),
        ),
        title: Text(
          widget.isNew ? 'New Note' : 'Edit Note',
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Toggle Microphone Button
          NoteIconButton(
            icon:
                _isMicOn ? FontAwesomeIcons.stop : FontAwesomeIcons.microphone,
            onPressed: _toggleMic,
          ),
          // Save Button (only shows if there's content to save)
          NoteIconButton(
            icon: FontAwesomeIcons.check,
            onPressed: _canSaveNote ? _saveNote : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language Dropdowns
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: white, // Background color inside the border
                      border: Border.all(
                          color: Colors.grey,
                          width: 1.5), // Border color and width
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    alignment: Alignment.centerLeft,
                    height: 56, // Ensures consistent height
                    child: DropdownButton<String>(
                      value: _inputLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          _inputLanguage = newValue!;
                        });
                      },
                      items:
                          languages.map<DropdownMenuItem<String>>((language) {
                        return DropdownMenuItem<String>(
                          value: language['code'],
                          child: Text(language['name']!),
                        );
                      }).toList(),
                      underline: Container(), // Removes default underline
                      isExpanded:
                          true, // Ensures the dropdown fills the Container width
                    ),
                  ),
                ),
                SizedBox(width: 16), // Space between dropdowns
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color inside the border
                      border: Border.all(
                          color: Colors.grey,
                          width: 1.5), // Border color and width
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    alignment: Alignment.centerLeft,
                    height: 56,
                    child: DropdownButton<String>(
                      value: _targetLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          _targetLanguage = newValue!;
                        });
                      },
                      items:
                          languages.map<DropdownMenuItem<String>>((language) {
                        return DropdownMenuItem<String>(
                          value: language['code'],
                          child: Text(language['name']!),
                        );
                      }).toList(),
                      underline: Container(),
                      isExpanded: true,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title...',
                hintStyle: TextStyle(color: gray500),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write me...',
                    hintStyle: TextStyle(color: gray500),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            if (_translatedText.isNotEmpty) ...[
              Divider(),
              Text(
                'Translated Text: $_translatedText',
                style: TextStyle(fontSize: 16, color: maincolor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
