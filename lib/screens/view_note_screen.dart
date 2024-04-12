import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/screens/main_screen.dart';
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

  void dispose() {
    // TODO: implement dispose
    formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
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

                  var note = Note(
                    id: widget.note.id,
                    title: title[0],
                    description: description,
                    createdAt: widget.note.createdAt,
                    updatedAt: DateTime.now(),
                  );

                  Provider.of<NotesController>(context, listen: false)
                      .updateNote(note);

                  Provider.of<NotesController>(context, listen: false)
                      .goToMain(context);
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

                              Provider.of<NotesController>(context,
                                      listen: false)
                                  .goToMain(context);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const MainScreen()),
                              // ).then((value) => setState(() {}));
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
        note: widget.note,
        controller: formController,
      ),
    );
  }
}

// IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       shape: BeveledRectangleBorder(),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('No'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Provider.of<NotesController>(context, listen: false)
//                                 .deleteNote(widget.note.id as int);

//                             Provider.of<NotesController>(context, listen: false)
//                                 .goToMain(context);
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //       builder: (context) => const MainScreen()),
//                             // ).then((value) => setState(() {}));
//                           },
//                           child: Text('Yes'),
//                         ),
//                       ],
//                       content: const Text(
//                           'Are you sure you want to delete this note?'),
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(Icons.delete)),
//           IconButton(
//             onPressed: () {
//               var description = formController.text;
//               var title = description.split('\n');

//               var note = Note(
//                 id: widget.note.id,
//                 title: title[0],
//                 description: description,
//                 createdAt: widget.note.createdAt,
//                 updatedAt: DateTime.now(),
//               );

//               Provider.of<NotesController>(context, listen: false)
//                   .updateNote(note);

//               Provider.of<NotesController>(context, listen: false)
//                   .goToMain(context);

//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => const MainScreen()),
//               // ).then((value) => setState(() {}));
//             },
//             icon: const Icon(Icons.save),
//             color: Colors.white,
//           ),
