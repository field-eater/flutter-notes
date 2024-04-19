import 'package:PHNotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaffoldLeading extends StatelessWidget {
  const ScaffoldLeading({super.key, required this.notesController});
  final NotesController notesController;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        notesController.clearBatch();

        notesController.hasSelect.value = false;
      },
    );
  }
}
