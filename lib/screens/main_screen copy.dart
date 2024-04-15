import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/screens/create_note_screen.dart';
import 'package:notes_app/screens/view_note_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late Stream<List<Note>> futureNotes;
  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  _init() {
    futureNotes =
        Provider.of<NotesController>(context, listen: false).getNotes();
    controller = context.read<NotesController>().formController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamProvider<List<Note>>(
          initialData: [],
          create: (context) => futureNotes,
          child: Consumer<List<Note>>(
            builder: (context, notes, child) {
              if (notes.isNotEmpty) {
                return SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    children: [
                      ...notes.map((note) {
                        return GridTile(
                          child: Card(
                            child: InkWell(
                              onLongPress: () {},
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) => ViewNoteScreen(
                                          note: note,
                                        )),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            note.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat.yMMMMd('en_US')
                                                .format(
                                                    note.updatedAt as DateTime)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Text(
                                        note.description,
                                        maxLines: 7,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color:
                                              Color.fromARGB(255, 71, 70, 70),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text(
                  'No notes',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
