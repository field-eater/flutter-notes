import 'package:PHNotes/components/category_chips.dart';
import 'package:PHNotes/controllers/category_controller.dart';
import 'package:PHNotes/controllers/note_controller.dart';
import 'package:PHNotes/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:PHNotes/models/note_model.dart';

class NoteTextfield extends StatefulWidget {
  const NoteTextfield({
    super.key,
    this.note,
    this.focusNode,
    required this.controller,
    required this.route,
    required this.undoController,
    required this.dropdownController,
    required this.categories,
  });

  final Note? note;
  final FocusNode? focusNode;
  final List categories;
  final TextEditingController controller;
  final TextEditingController dropdownController;
  final UndoHistoryController undoController;
  final String route;

  @override
  _NoteTextfieldState createState() => _NoteTextfieldState();
}

class _NoteTextfieldState extends State<NoteTextfield> {
  late int _counterText = 0;
  var date = DateFormat.yMMMMd('en_US').format(DateTime.now()).toString();
  final CategoryController categoryController = Get.put(CategoryController());

  var updatedAt = '';
  var categoryTitle = '';

// to open keyboard call this function;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.route == 'view_note') {
      _initNoteCategory();
    }
    if (widget.note != null) {
      widget.controller.text = widget.note!.description;
      _counterText = widget.note!.description.length;
    }

    if (updatedAt.isNotEmpty) {
      updatedAt = DateFormat.yMMMMd('en_US')
          .format(DateTime.parse(updatedAt))
          .toString();
    }
  }

  _initNoteCategory() async {
    final category = await categoryController.getCategory(
        'id', widget.note!.categoryId.toString());

    // if (category.id != 1) {
    widget.dropdownController.text = category.title;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$date | ${_counterText.toString()} Characters"),
                DropdownMenu<String>(
                    controller: widget.dropdownController,
                    dropdownMenuEntries: widget.categories
                        .map<DropdownMenuEntry<String>>((value) {
                      return DropdownMenuEntry<String>(
                        value: value.id.toString(),
                        label: value.title,
                      );
                    }).toList(),
                    onSelected: ((String? value) async {
                      setState(() async {
                        //TODO:
                      });
                    })),
              ],
            ),
            TextField(
              focusNode: widget.focusNode,
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
