import 'package:PHNotes/models/category_model.dart';
import 'package:PHNotes/services/notes_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  var categories = [].obs;
  var dropdownCategories = [].obs;
  var category = CategoryModel(title: '').obs;

  void setCategories() async {
    categories.value = await getCategories();
    setDropdownCategories();
    update();
  }

  void setDropdownCategories() {
    dropdownCategories.value =
        categories.where((element) => element.title != 'All').toList();
    update();
  }

  Future<void> createCategory(CategoryModel category) async {
    // Get a reference to the database.
    final db = await database();

    // Insert the  into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Category is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    update();
  }

  Future<CategoryModel> getCategory(String title) async {
    final db = await database();
    final category = await db.query(
      'categories',
      // Ensure that the Category has a matching title.
      where: 'title = ?',
      // Pass the Category's id as a whereArg to prevent SQL injection.
      whereArgs: [title],
    );

    return switch (category) {
      {
        'id': int id,
        'title': String title,
      } =>
        CategoryModel(
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load category.'),
    };
  }

  Future<List<CategoryModel>> getCategories() async {
    // Get a reference to the database.
    final db = await database();

    // Query the table for all the Notes.
    final List<Map<String, Object?>> categoryMaps =
        await db.query('categories');

    return [
      for (final {
            'id': id as int,
            'title': title as String,
          } in categoryMaps)
        CategoryModel(
          id: id,
          title: title,
        ),
    ];
  }

  Future<void> updateNote(CategoryModel category) async {
    // Get a reference to the database.
    final db = await database();

    // Update the given Category.
    await db.update(
      'categories',
      category.toMap(),
      // Ensure that the Category has a matching id.
      where: 'id = ?',
      // Pass the Category's id as a whereArg to prevent SQL injection.
      whereArgs: [category.id],
    );
    update();
  }

  Future<void> deleteCategory(int id) async {
    final db = await database();

    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    update();
  }
}
