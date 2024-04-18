import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:PHNotes/controllers/note_controller.dart';
import 'package:PHNotes/models/note_model.dart';
import 'package:PHNotes/screens/create_note_screen.dart';
import 'package:PHNotes/screens/view_note_screen.dart';

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
  bool isFetching = true;

  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    _notes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _init() {
    selectedNotes =
        Provider.of<NotesController>(context, listen: false).selectedNotes;

    controller = context.read<NotesController>().formController;
  }

  _notes() async {
    await Provider.of<NotesController>(context, listen: false)
        .getNotes()
        .then((value) {
      setState(() {
        notes = value;
        notes.sort((b, a) {
          return a.updatedAt!.compareTo(b.updatedAt!);
        });
        if (notes.isEmpty) {
          hasSelect = false;
        }
        isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
    if (isFetching) {
      return Skeletonizer(
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(notes.length, (index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Placeholder',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                    const SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        'Placeholder',
                        maxLines: 7,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 71, 70, 70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    } else {
      if (notes.isNotEmpty) {
        return SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            children: List.generate(notes.length, (index) {
              return Card(
                color: (selectedNotes.contains(notes[index].id))
                    ? Theme.of(context).primaryColor
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
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: ((context) => ViewNoteScreen(
                                      note: notes[index],
                                    )),
                              ),
                            )
                            .then((value) => setState(() {}));
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat.MMMd('en_US')
                                    .add_jm()
                                    .format(notes[index].updatedAt as DateTime)
                                    .toString(),
                                style: const TextStyle(
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
  }

  Widget? scaffoldFloatingActionButton() {
    if (!hasSelect) {
      return FloatingActionButton(
        foregroundColor: Theme.of(context).cardColor,
        backgroundColor: Theme.of(context).primaryColor,
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
        if (selectedNotes.isEmpty) {
          return const Text(
            'Select items',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (selectedNotes.length == 1) {
          return Text(
            "${selectedNotes.length} item selected",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        } else if (selectedNotes.length > 1) {
          return Text(
            "${selectedNotes.length} items selected",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }
      }
      return const Text(
        'PHNotes',
        style: TextStyle(
          color: Colors.white,
        ),
      );
    });
  }

  Widget? scaffoldLeading() {
    if (hasSelect) {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectedNotes = [];
            ;
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
                  selectedNotes = [];
                  ;
                });
              } else {
                setState(() {
                  selectedNotes = [];
                  ;
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
                                    selectedNotes = [];
                                    ;
                                  });
                                },
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<NotesController>(context,
                                          listen: false)
                                      .deleteNotes(selectedNotes);

                                  setState(() {
                                    selectedNotes = [];
                                    hasSelect = false;
                                    ;
                                  });

                                  _notes();

                                  Navigator.of(context).pop();
                                },
                                child: Text("Yes"),
                              )
                            ],
                            content: (selectedNotes.length == 1)
                                ? Text(
                                    'Are you sure you want to delete ${selectedNotes.length} note?')
                                : Text(
                                    'Are you sure you want to delete ${selectedNotes.length} notes?'),
                          );
                        });
                  },
            icon: Icon(Icons.delete))
      ];
    }
    return null;
  }
}
