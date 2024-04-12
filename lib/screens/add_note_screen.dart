import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/note_controller.dart';

import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/screens/main_screen.dart';
import 'package:notes_app/widgets/note_textfield.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  AddNoteScreen({
    super.key,
  });

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController formController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add a note',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                var description = formController.text;
                var title = description.split('\n');
                Note note = Note(
                  title: title[0],
                  description: description,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                Provider.of<NotesController>(context, listen: false)
                    .insertNote(note);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MainScreen()),
                // ).then((value) => setState(() {}));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Note saved successfully'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        Provider.of<NotesController>(context, listen: false)
                            .undoSave();
                      },
                    ),
                  ),
                );

                Provider.of<NotesController>(context, listen: false)
                    .goToMain(context);
              },
              icon: const Icon(Icons.save),
              color: Colors.white,
            ),
          ],
        ),
        body: NoteTextfield(controller: formController));
  }
}
