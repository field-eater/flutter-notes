import 'package:PHNotes/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:PHNotes/controllers/note_controller.dart';

import 'package:PHNotes/models/note_model.dart';

import 'package:PHNotes/widgets/note_textfield.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatefulWidget {
  CreateNoteScreen({
    super.key,
  });

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController formController = TextEditingController();
  UndoHistoryController undoController = UndoHistoryController();

  bool isSnackBarTapped = false;
  @override
  void dispose() {
    // TODO: implement dispose
    formController.dispose();

    undoController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var notesController = Provider.of<NotesController>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Add a note',
            // style: TextStyle(color: Colors.white),
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: undoController,
              builder: (context, value, child) {
                return Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.undo),
                      style: (value.canUndo)
                          ? IconButton.styleFrom(foregroundColor: Colors.white)
                          : IconButton.styleFrom(
                              foregroundColor: Theme.of(context).disabledColor),
                      onPressed: () {
                        if (value.canUndo) {
                          undoController.undo();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.redo),
                      style: (value.canRedo)
                          ? IconButton.styleFrom(foregroundColor: Colors.white)
                          : IconButton.styleFrom(foregroundColor: Colors.grey),
                      onPressed: () {
                        if (value.canRedo) {
                          undoController.redo();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
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

                if (description.isNotEmpty) {
                  notesController.insertNote(note);

                  // Navigator.pop(context);
                  notesController.goToMain(context);
                } else {
                  notesController.goToMain(context);
                }
              },
              icon: const Icon(Icons.check),
              color: Colors.white,
            ),
          ],
        ),
        body: NoteTextfield(
          undoController: undoController,
          controller: formController,
          route: 'create_note',
        ));
  }
}
