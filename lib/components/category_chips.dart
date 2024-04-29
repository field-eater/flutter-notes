import 'package:PHNotes/controllers/category_controller.dart';
import 'package:PHNotes/controllers/note_controller.dart';

import 'package:PHNotes/models/category_model.dart';
import 'package:PHNotes/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categoryController,
    required this.notesController,
  });
  final CategoryController categoryController;
  final NotesController notesController;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    var currentCategory = 'All'.obs;

    return Obx(
      () => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 5.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: chips(context, currentCategory, controller),
        ),
      ),
    );
  }

  List<Widget> chips(BuildContext context, var currentCategory,
      TextEditingController controller) {
    var length = categoryController.categories.length;

    var actionChip = ActionChip(
      label: Icon(
        color: Theme.of(context).primaryColor,
        Icons.add_to_photos_outlined,
        size: 16,
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Category'),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Enter Category'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final category = CategoryModel(title: controller.text);
                      categoryController.createCategory(category);

                      Get.back();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            });
      },
    );

    var verticalDivider = VerticalDivider();

    var chips = List<Widget>.generate(length, (index) {
      return ChoiceChip(
        showCheckmark: false,
        selectedColor: Theme.of(context).primaryColor,
        label: Text(
          categoryController.categories[index].title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        selected:
            currentCategory.value == categoryController.categories[index].title,
        // shape: StadiumBorder(),
        onSelected: (bool selected) {
          if (selected) {
            currentCategory.value = categoryController.categories[index].title;
            notesController.categoryId.value =
                categoryController.categories[index].id;
            notesController.filterNotesByCategory();
          }
        },
      );
    });
    chips.add(verticalDivider);
    chips.add(actionChip);
    return chips;
  }
}
