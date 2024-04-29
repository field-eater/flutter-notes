import 'package:PHNotes/controllers/category_controller.dart';
import 'package:PHNotes/models/category_model.dart';
import 'package:flutter/material.dart';

import 'package:PHNotes/controllers/note_controller.dart';
import 'package:PHNotes/models/note_model.dart';

import 'package:PHNotes/components/note_textfield.dart';
import 'package:get/get.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({super.key, this.categories});

  final List? categories;

  @override
  _ViewNoteScreenState createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  TextEditingController formController = TextEditingController();
  CategoryController categoryController = Get.put(CategoryController());
  final UndoHistoryController undoController = UndoHistoryController();
  final TextEditingController dropdownController = TextEditingController();

  void updateNote(Note note, NotesController notesController) async {
    var description = formController.text;
    var categoryTitle = dropdownController.text;
    var title = description.split('\n');
    var category =
        await categoryController.getCategory('id', note.categoryId.toString());
    CategoryModel newCategory;

    if (categoryTitle != '1') {
      newCategory =
          await categoryController.getCategory('title', categoryTitle);
    } else {
      newCategory = await categoryController.getCategory('id', '1');
    }

    var newNote = Note(
      id: note.id,
      title: title[0],
      description: description,
      categoryId:
          (categoryTitle != category.title) ? newCategory.id : note.categoryId,
      createdAt: note.createdAt,
      updatedAt: DateTime.now(),
    );

    if (description != note.description ||
        categoryTitle != category.title && newCategory.id != 1) {
      notesController.updateNote(newNote);
      notesController.goToMain();
    }
    // else if (description != note.description &&
    //     categoryTitle != category.title &&
    //     category.id == 1) {
    //   notesController.goToMain();
    // }
    else {
      notesController.goToMain();
    }
  }

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
    final note = ModalRoute.of(context)!.settings.arguments as Note;
    NotesController notesController = Get.put(NotesController());
    CategoryController categoryController = Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            updateNote(note, notesController);
          },
        ),
        title: Text(
          note.title,
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
                            Get.back();
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            notesController.deleteNote(note.id as int);

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

                            Get.back();
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
        note: note,
        controller: formController,
        route: 'view_note',
        categories: categoryController.dropdownCategories,
        dropdownController: dropdownController,
      ),
    );
  }
}
