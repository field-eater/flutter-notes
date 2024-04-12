import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/screens/create_notes_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Note>> notes;
  List<Note> emptyNotes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init() {
    notes = Provider.of<NotesController>(context, listen: false).getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FutureProvider<List<Note>>(
            initialData: emptyNotes,
            create: (context) => notes,
            child: Consumer<List<Note>>(
              builder: (context, notes, child) {
                if (notes.isNotEmpty) {
                  notes.map((note) {
                    return Card(
                      child: Text(note.title),
                    );
                  });
                } else {
                  return const Center(
                    child: Text(
                      'No notes',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateNotesScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
