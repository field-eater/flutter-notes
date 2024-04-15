import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/models/note_model.dart';

import 'package:notes_app/widgets/note_textfield.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notesController = Provider.of<NotesController>(context);
    return Scaffold(
      appBar: AppBar(
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
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.save,
                      color: Colors.deepPurple,
                    ),
                    Text('Save'),
                  ],
                ),
                onTap: () {
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

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note updated successfully'),
                      ),
                    );

                    notesController.goToMain(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('No new changes were made'),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              PopupMenuItem(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.deepPurple,
                    ),
                    Text('Delete'),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: BeveledRectangleBorder(),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<NotesController>(context,
                                      listen: false)
                                  .deleteNote(widget.note.id as int);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: const Row(
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
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      Provider.of<NotesController>(context,
                                              listen: false)
                                          .insertNote(widget.note);
                                    },
                                  ),
                                ),
                              );

                              Provider.of<NotesController>(context,
                                      listen: false)
                                  .goToMain(context);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                        content: const Text(
                            'Are you sure you want to delete this note?'),
                      );
                    },
                  );
                },
              ),
            ];
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