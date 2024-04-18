import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:PHNotes/controllers/note_controller.dart';
import 'package:PHNotes/models/note_model.dart';

import 'package:PHNotes/widgets/note_textfield.dart';
import 'package:provider/provider.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({super.key, required this.note});

  final Note note;

  @override
  _ViewNoteScreenState createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  TextEditingController formController = TextEditingController();
  final UndoHistoryController undoController = UndoHistoryController();

  late Future<Note> prevNote;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            var description = formController.text;
            var title = description.split('\n');

            var newNote = Note(
              id: widget.note.id,
              title: title[0],
              description: description,
              createdAt: widget.note.createdAt,
              updatedAt: DateTime.now(),
            );

            if (description != widget.note.description) {
              notesController.updateNote(newNote);

              notesController.goToMain(context);
            } else {
              notesController.goToMain(context);
            }
            ;
          },
        ),
        title: Text(
          widget.note.title,
          style: const TextStyle(color: Colors.white),
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
                        : IconButton.styleFrom(foregroundColor: Colors.grey),
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
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: BeveledRectangleBorder(),
                      actions: [
                        TextButton(
                          onPressed: () {
                            notesController.goToMain(context);
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<NotesController>(context, listen: false)
                                .deleteNote(widget.note.id as int);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Note deleted successfully'),
                                  ],
                                ),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                      content: const Text(
                          'Are you sure you want to delete this note?'),
                    );
                  },
                );
              })
        ],
      ),
      body: NoteTextfield(
        undoController: undoController,
        note: widget.note,
        controller: formController,
        route: 'view_note',
      ),
    );
  }
}
