import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/screens/create_note_screen.dart';
import 'package:notes_app/screens/view_note_screen.dart';

import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Note> notes = [];
  late List<int> selectedNotes;
  bool hasSelect = false;

  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _init() async {
    selectedNotes =
        Provider.of<NotesController>(context, listen: false).selectedNotes;
    await Provider.of<NotesController>(context, listen: false)
        .getNotes()
        .then((value) {
      setState(() {
        notes = value;
        notes.sort((b, a) {
          return a.updatedAt!.compareTo(b.updatedAt!);
        });
      });
    });
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: gridNotes(),
      ),
      floatingActionButton: scaffoldFloatingActionButton(),
    );
  }

  Widget? gridNotes() {
    if (notes.isNotEmpty) {
      return SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          children: List.generate(notes.length, (index) {
            return Card(
              color: (selectedNotes.contains(notes[index].id))
                  ? const Color.fromARGB(255, 167, 145, 229)
                  : null,
              child: InkWell(
                onLongPress: () {
                  setState(() {
                    hasSelect = true;
                    if (selectedNotes.contains(notes[index].id as int)) {
                      selectedNotes.remove(notes[index].id as int);
                    } else {
                      selectedNotes.add(notes[index].id as int);
                    }
                  });
                },
                onTap: () {
                  if (selectedNotes.isEmpty) {
                    if (!hasSelect) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => ViewNoteScreen(
                                note: notes[index],
                              )),
                        ),
                      );
                    } else {
                      setState(() {
                        if (selectedNotes.contains(notes[index].id as int)) {
                          selectedNotes.remove(notes[index].id as int);
                        } else {
                          selectedNotes.add(notes[index].id as int);
                        }
                      });
                    }
                  } else {
                    setState(() {
                      if (selectedNotes.contains(notes[index].id as int)) {
                        selectedNotes.remove(notes[index].id as int);
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notes[index].title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat.MMMd('en_US')
                                  .add_jm()
                                  .format(notes[index].updatedAt as DateTime)
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
                            color: Color.fromARGB(255, 71, 70, 70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'No Notes',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
  }

  Widget? scaffoldFloatingActionButton() {
    if (!hasSelect) {
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
    return Builder(builder: (context) {
      if (hasSelect) {
        if (selectedNotes.length == 0) {
          return const Text(
            'Select items',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (selectedNotes.length == 1) {
          return Text(
            "${selectedNotes.length} item selected",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (selectedNotes.length > 1) {
          return Text(
            "${selectedNotes.length} items selected",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      }
      return const Text(
        'Notes',
        style: TextStyle(color: Colors.white),
      );
    });
  }

  Widget? scaffoldLeading() {
    if (hasSelect) {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectedNotes.clear();
            hasSelect = false;
          });
        },
      );
    }
    return null;
  }

  List<Widget>? scaffoldActions() {
    if (hasSelect) {
      return [
        IconButton(
            onPressed: () {
              List<int> ids = [];

              notes.forEach((e) => ids.add(e.id as int));

              if (ids.every((id) => selectedNotes.contains(id))) {
                setState(() {
                  selectedNotes.clear();
                });
              } else {
                setState(() {
                  selectedNotes.clear();
                  selectedNotes.addAll(ids);
                });
              }
            },
            icon: const Icon(Icons.checklist_outlined)),
        IconButton(
            onPressed: (selectedNotes.isEmpty)
                ? null
                : () {
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
                                    selectedNotes.clear();
                                  });
                                },
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<NotesController>(context,
                                          listen: false)
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
                                    selectedNotes.clear();
                                  });

                                  Provider.of<NotesController>(context,
                                          listen: false)
                                      .getNotes()
                                      .then((value) {
                                    setState(() {
                                      notes = value;
                                      notes.sort((a, b) {
                                        var prevNote = a.updatedAt;
                                        var nextNote = b.updatedAt;
                                        return prevNote!.compareTo(nextNote!);
                                      });
                                      if (notes.isEmpty) {
                                        hasSelect = false;
                                      }
                                    });
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
