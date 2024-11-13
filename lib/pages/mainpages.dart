import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_but_better/change_notifiers/new_note_controller.dart';
import 'package:notes_but_better/change_notifiers/notes_provider.dart';
import 'package:notes_but_better/constants/constants.dart';
import 'package:notes_but_better/models/note.dart';
import 'package:notes_but_better/pages/loginpage.dart';
import 'package:notes_but_better/pages/notedetailpages.dart';
import 'package:notes_but_better/widgets/notefloatingactionbutton.dart';
import 'package:notes_but_better/widgets/notegrid.dart';
import 'package:notes_but_better/widgets/noteiconbutton.dart';
import 'package:notes_but_better/widgets/searchbar.dart';
import 'package:provider/provider.dart';

import '../widgets/empty_note.dart';

class Mainpages extends StatefulWidget {
  const Mainpages({super.key});

  @override
  State<Mainpages> createState() => _MainpagesState();
}

class _MainpagesState extends State<Mainpages> {
  @override
  void initState() {
    TextEditingController _searchController = TextEditingController();
    List<Note> _filteredNotes = [];

    super.initState();
    // Fetch notes when the main page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotesProvider>(context, listen: false).fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the default back arrow
        title: const Text(
          'Notes but better',
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: maincolor,
        actions: [
          NoteIconButton(
            icon: FontAwesomeIcons.rightFromBracket,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Confirm Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: maincolor, // Customize title color
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to log out?",
                      style: TextStyle(
                        color: gray700, // Customize content text color
                      ),
                    ),
                    backgroundColor: Colors.white, // Customize background color
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
                          FirebaseAuth.instance
                              .signOut(); // Sign out from Firebase
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: maincolor, // Customize button color
                            fontWeight:
                                FontWeight.bold, // Make the button text bold
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: NoteFloatingActionBtn(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => NewNoteController(),
                child: Notedetailpages(isNew: true),
              ),
            ),
          );
        },
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, _) {
          final notes = notesProvider.notes;

          if (notes.isEmpty) {
            return EmptyNote();
          } else {
            return Container(
                margin: EdgeInsets.all(16), child: NotesGrid(notes: notes));
          }
        },
      ),
    );
  }
}
