import 'dart:async';

import 'package:PHNotes/components/category_chips.dart';
import 'package:PHNotes/controllers/category_controller.dart';
import 'package:PHNotes/widgets/batch_delete.dart';
import 'package:PHNotes/components/grid_notes.dart';
import 'package:PHNotes/widgets/scaffold_leading.dart';
import 'package:PHNotes/widgets/scaffold_title.dart';
import 'package:PHNotes/widgets/select_all.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import 'package:PHNotes/controllers/note_controller.dart';

import 'package:PHNotes/screens/create_note_screen.dart';

import 'package:skeletonizer/skeletonizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // var isFetching = false.obs;

  late TextEditingController controller;

  NotesController notesController = Get.put(NotesController());
  CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notesController.setNotes();
    categoryController.setCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          actions: (notesController.hasSelect.isTrue)
              ? [
                  SelectAll(notesController: notesController),
                  BatchDelete(notesController: notesController)
                ]
              : null,
          leading: (notesController.hasSelect.isTrue)
              ? ScaffoldLeading(notesController: notesController)
              : null,
          title: ScaffoldTitle(),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (notesController.hasSelect.isFalse)
                CategoryChips(
                    categoryController: categoryController,
                    notesController: notesController),
              Expanded(
                child: GridNotes(),
              ),
            ],
          ),
        ),
        floatingActionButton: (notesController.hasSelect.isFalse)
            ? scaffoldFloatingActionButton()
            : null,
      );
    });
  }

  Widget scaffoldFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      onPressed: () {
        Get.to(CreateNoteScreen());
      },
      child: const Icon(Icons.add),
    );
  }
}
