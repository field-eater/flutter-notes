import 'package:PHNotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaffoldTitle extends StatelessWidget {
  ScaffoldTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
      builder: (notesController) {
        if (notesController.hasSelect.isTrue) {
          if (notesController.selectedNotes.isEmpty) {
            return const Text(
              'Select items',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          } else if (notesController.selectedNotes.length == 1) {
            notesController.selectedNotes.refresh();
            return Text(
              "${notesController.selectedNotes.length} item selected",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          } else if (notesController.selectedNotes.length > 1) {
            notesController.selectedNotes.refresh();
            return Text(
              "${notesController.selectedNotes.length} items selected",
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
      },
    );
  }
}
