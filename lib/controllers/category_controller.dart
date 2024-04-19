import 'package:PHNotes/models/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  var categories = [].obs;
  var category = CategoryModel(categoryTitle: '').obs;
}
