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

class _MainScreenState extends State<MainScreen> {
  late Future<List<Note>> futureNotes;
  late List<int> selectedNotes;
  final FocusNode _focusNode = FocusNode();

  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  _init() {
    selectedNotes =
        Provider.of<NotesController>(context, listen: false).selectedNotes;
    futureNotes =
        Provider.of<NotesController>(context, listen: false).getNotes();

    // streamedNotes = Provider.of<NotesController>(context, listen: false)
    //     .streamFromFutures(futureNotes);
    controller = context.read<NotesController>().formController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: scaffoldActions(),
        leading: scaffoldLeading(),
        title: scaffoldTitle(),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureProvider<List<Note>>(
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
                      children: List.generate(notes.length, (index) {
                        return GridTile(
                          child: Card(
                            color: (selectedNotes.contains(notes[index].id))
                                ? const Color.fromARGB(255, 167, 145, 229)
                                : null,
                            child: InkWell(
                              focusNode: _focusNode,
                              onLongPress: () {
                                setState(() {
                                  if (selectedNotes
                                      .contains(notes[index].id as int)) {
                                    selectedNotes
                                        .remove(notes[index].id as int);
                                  } else {
                                    selectedNotes.add(notes[index].id as int);
                                  }
                                });
                              },
                              onTap: () {
                                if (selectedNotes.isEmpty) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: ((context) => ViewNoteScreen(
                                            note: notes[index],
                                          )),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    if (selectedNotes
                                        .contains(notes[index].id as int)) {
                                      selectedNotes
                                          .remove(notes[index].id as int);
                                    } else {
                                      selectedNotes.add(notes[index].id as int);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notes[index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat.yMMMMd('en_US')
                                                .format(notes[index].updatedAt
                                                    as DateTime)
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
                                        notes[index].description,
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
                      })),
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
      floatingActionButton: scaffoldFloatingActionButton(),
    );
  }

  Widget? scaffoldFloatingActionButton() {
    if (selectedNotes.isEmpty) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  Widget? scaffoldTitle() {
    return Text(
      selectedNotes.length < 1
          ? 'Notes'
          : "${selectedNotes.length} items selected",
      style: TextStyle(color: Colors.white),
    );
  }

  Widget? scaffoldLeading() {
    if (selectedNotes.length > 0) {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectedNotes = [];
          });
        },
      );
    }
    return null;
  }

  List<Widget>? scaffoldActions() {
    if (selectedNotes.isNotEmpty) {
      return [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: BeveledRectangleBorder(),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              selectedNotes = [];
                            });
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<NotesController>(context, listen: false)
                                .deleteNotes(selectedNotes);

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
                                    Text('Notes deleted successfully'),
                                  ],
                                ),
                              ),
                            );
                            setState(() {
                              selectedNotes = [];
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("Yes"),
                        )
                      ],
                      content: Text(
                          'Are you sure you want to delete ${selectedNotes.length} note(s)?'),
                    );
                  });
            },
            icon: Icon(Icons.delete))
      ];
    }
    return null;
  }
}
