import 'package:PHNotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';

class SelectAll extends StatelessWidget {
  const SelectAll({super.key, required this.notesController});
  final NotesController notesController;

  void selectAll() {
    List<int> ids = [];

    notesController.notes.forEach((e) => ids.add(e.id as int));

    if (ids.every((id) => notesController.selectedNotes.contains(id))) {
      notesController.clearBatch();
    } else {
      notesController.clearBatch();

      notesController.selectedNotes.addAll(ids);
      notesController.selectedNotes.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: selectAll,
      icon: const Icon(Icons.checklist_outlined),
    );
  }
}
