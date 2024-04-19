import 'package:PHNotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchDelete extends StatelessWidget {
  const BatchDelete({super.key, required this.notesController});
  final NotesController notesController;

  void batchDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: BeveledRectangleBorder(),
            actions: [
              TextButton(
                onPressed: () {
                  notesController.clearBatch();
                  Get.back();
                },
                child: Text("No"),
              ),
              TextButton(
                onPressed: () {
                  notesController
                      .deleteNotes(notesController.selectedNotes.value);

                  notesController.clearBatch();

                  notesController.hasSelect.value = false;

                  Get.back();
                },
                child: Text("Yes"),
              )
            ],
            content: (notesController.selectedNotes.length == 1)
                ? Text(
                    'Are you sure you want to delete ${notesController.selectedNotes.length} note?')
                : Text(
                    'Are you sure you want to delete ${notesController.selectedNotes.length} notes?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (notesController.selectedNotes.isEmpty)
            ? null
            : () {
                batchDelete(context);
              },
        icon: Icon(Icons.delete));
  }
}
