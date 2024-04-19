import 'package:PHNotes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({
    super.key,
    required this.notesController,
  });
  final NotesController notesController;

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  @override
  Widget build(BuildContext context) {
    var isCategorized = 0.obs;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5),
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 5.0,
        children: List<Widget>.generate(
            widget.notesController.categories.length, (index) {
          return ChoiceChip(
            showCheckmark: false,
            selectedColor: Theme.of(context).primaryColor,
            label: Text(
              widget.notesController.categories[index],
              style: Theme.of(context).textTheme.bodySmall,
            ),
            selected: isCategorized.value == index,
            shape: StadiumBorder(),
            onSelected: (bool selected) {
              isCategorized.value = selected ? index : 0;
            },
          );
        }),
      ),
    );
    ;
  }
}
