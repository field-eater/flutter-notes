import 'package:PHNotes/controllers/category_controller.dart';
import 'package:PHNotes/controllers/note_controller.dart';
import 'package:get/get.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotesController>(() => NotesController());
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
