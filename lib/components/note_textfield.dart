import 'package:PHNotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:PHNotes/models/note_model.dart';

class NoteTextfield extends StatefulWidget {
  const NoteTextfield({
    super.key,
    this.note,
    required this.controller,
    required this.route,
    required this.undoController,
  });

  final Note? note;
  final TextEditingController controller;
  final UndoHistoryController undoController;
  final String route;

  @override
  _NoteTextfieldState createState() => _NoteTextfieldState();
}

class _NoteTextfieldState extends State<NoteTextfield> {
  late int _counterText = 0;
  var date = DateFormat.yMMMMd('en_US').format(DateTime.now()).toString();

  var updatedAt = '';

// to open keyboard call this function;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      widget.controller.text = widget.note!.description;
      _counterText = widget.note!.description.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotesController notesController = Get.put(NotesController());
    String dropdownValue = notesController.categories.first;
    if (updatedAt.isNotEmpty) {
      updatedAt = DateFormat.yMMMMd('en_US')
          .format(DateTime.parse(updatedAt))
          .toString();
    }
    return Container(
      margin: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$date | ${_counterText.toString()} Characters"),
                DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    items: notesController.categories
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: ((String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    })),
              ],
            ),
            TextField(
              controller: widget.controller,
              undoController: widget.undoController,
              autofocus: (widget.route == 'create_note') ? true : false,
              onChanged: (value) {
                setState(() {
                  _counterText = value.length;
                });
              },
              maxLines: null,
              maxLength: 5000,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            )
          ],
        ),
      ),
    );
  }
}
