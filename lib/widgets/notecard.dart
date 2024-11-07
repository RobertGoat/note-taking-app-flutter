import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes_but_better/change_notifiers/notes_provider.dart';
import 'package:notes_but_better/constants/constants.dart';
import 'package:notes_but_better/models/note.dart';
import 'package:notes_but_better/pages/notedetailpages.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Notedetailpages(
              isNew: false,
              note: note,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: maincolor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.title != null) ...[
              Text(
                note.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: maincolor,
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
            if (note.content != null) ...[
              Expanded(
                child: Text(
                  note.content!,
                  style: TextStyle(color: gray900),
                ),
              ),
            ],
            Spacer(),
            Text(
              'Date created:',
              style: TextStyle(
                fontSize: 10,
                color: gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  DateFormat('dd MMM, y ').format(
                    DateTime.fromMicrosecondsSinceEpoch(note.dateCreated),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                // Make the trash icon functional
                GestureDetector(
                  onTap: () {
                    // Show a confirmation dialog or delete directly
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Note",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: maincolor,
                              )),
                          content: Text(
                            "Are you sure you want to delete this note?",
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
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: gray700),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Pass the entire note object here
                                // context.read<NotesProvider>().deleteNote(note);
                                Navigator.pop(context); // Close the dialog
                                Provider.of<NotesProvider>(context,
                                        listen: false)
                                    .deleteNote(note.id);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: maincolor, // Customize button color
                                  fontWeight: FontWeight
                                      .bold, // Make the button text bold
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: gray500,
                    size: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
