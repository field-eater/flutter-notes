import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/forms/notes_form.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:provider/provider.dart';

class CreateNotesScreen extends StatefulWidget {
  CreateNotesScreen({super.key});

  @override
  _CreateNotesScreenState createState() => _CreateNotesScreenState();
}

class _CreateNotesScreenState extends State<CreateNotesScreen> {
  final formController = TextEditingController();
  @override
  void dispose() {
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
              Navigator.of(context).pop();
            },
            icon: IconButton(
              onPressed: () {
                var note = Note(
                  id: 1,
                  title: 'Notes',
                  description: formController.text,
                  date: DateTime.now(),
                );
                Provider.of<NotesController>(context, listen: false)
                    .insertNote(note);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Expanded(
        child: Container(
          margin: EdgeInsets.all(10),
          child: TextField(
            controller: formController,
            keyboardType: TextInputType.multiline,
            maxLines: 99999,
            decoration: InputDecoration.collapsed(
              hintText: "Insert your message",
            ),
            scrollPadding: EdgeInsets.all(20.0),
            autofocus: true,
          ),
        ),
      ),
    );
  }
}
