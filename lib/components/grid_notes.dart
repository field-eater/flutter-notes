import 'package:PHNotes/controllers/note_controller.dart';
import 'package:PHNotes/screens/view_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GridNotes extends StatefulWidget {
  const GridNotes({Key? key}) : super(key: key);

  @override
  _GridNotesState createState() => _GridNotesState();
}

class _GridNotesState extends State<GridNotes> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(builder: (notesController) {
      if (notesController.notes.isNotEmpty) {
        return SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            children:
                List.generate(notesController.notes.value.length, (index) {
              return Card(
                color: (notesController.selectedNotes
                        .contains(notesController.notes[index].id))
                    ? Theme.of(context).primaryColor
                    : null,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  onLongPress: () {
                    notesController.hasSelect.value = true;
                    notesController.updateSelectedNotes(index);
                  },
                  onTap: () {
                    if (notesController.selectedNotes.isEmpty) {
                      if (notesController.hasSelect.isFalse) {
                        Get.to(ViewNoteScreen(),
                            arguments: notesController.notes[index]);
                      } else {
                        // notesController.selectedNotes.refresh();

                        notesController.updateSelectedNotes(index);
                        notesController.toggleSelect();
                      }
                    } else {
                      // notesController.selectedNotes.refresh();

                      notesController.updateSelectedNotes(index);
                      notesController.toggleSelect();
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
                                notesController.notes[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat.MMMd('en_US')
                                    .add_jm()
                                    .format(notesController
                                        .notes[index].updatedAt as DateTime)
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
                            notesController.notes[index].description,
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
      }
      return LayoutBuilder(builder: ((context, constraints) {
        return Container(
          constraints: constraints,
          alignment: Alignment.center,
          child: Text(
            'No notes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
      }));
    });
  }
}
