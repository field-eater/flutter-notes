import 'dart:async';
import 'package:flutter/material.dart';
import 'package:PHNotes/models/note_model.dart';
import 'package:PHNotes/screens/main_screen.dart';
import 'package:PHNotes/services/notes_service.dart';
import 'package:get/get.dart';

import 'package:sqflite/sqflite.dart';

class NotesController extends GetxController {
  TextEditingController formController = TextEditingController();
  StreamController noteStreamController = StreamController();

  static NotesController get to => Get.find();

  final selectedNotes = [].obs;

  final notes = [].obs;
  final note = Note(title: '', description: '').obs;
  final hasSelect = false.obs;

  List categories = [
    "All",
    "Personal",
    "Work",
    "Family",
    "Others",
  ].obs;

  Future<void> insertNote(Note note) async {
    // Get a reference to the database.
    final db = await database();

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    update();
  }

  Future<Note> getNote(int id) async {
    final db = await database();
    final note = await db.query(
      'notes',
      // Ensure that the Note has a matching id.
      where: 'id = ?',
      // Pass the Note's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    return switch (note) {
      {
        'id': int noteId,
        'title': String title,
        'description': String description,
        'created_at': DateTime createdAt,
        'updated_at': DateTime updatedAt,
      } =>
        Note(
          id: noteId,
          title: title,
          description: description,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      _ => throw const FormatException('Failed to load note.'),
    };
  }

  // A method that retrieves all the Notes from the Notes table.
  Future<List<Note>> getNotes() async {
    // Get a reference to the database.
    final db = await database();

    // Query the table for all the Notes.
    final List<Map<String, Object?>> noteMaps = await db.query('Notes');

    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'description': description as String,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
          } in noteMaps)
        Note(
          id: id,
          title: title,
          description: description,
          createdAt: DateTime.parse(createdAt),
          updatedAt: DateTime.parse(updatedAt),
        ),
    ];
  }

  void setNotes() async {
    notes.value = await getNotes();
    sortDesc();
    update();
  }

  void sortDesc() {
    notes.value.sort(
      (b, a) {
        return a.updatedAt.compareTo(b.updatedAt);
      },
    );
  }

  Future<void> updateNote(Note note) async {
    // Get a reference to the database.
    final db = await database();

    // Update the given Note.
    await db.update(
      'notes',
      note.toMap(),
      // Ensure that the Note has a matching id.
      where: 'id = ?',
      // Pass the Note's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
    update();
  }

  Future<void> deleteNotes(List ids) async {
    final db = await database();

    await db.delete('notes',
        where: 'id IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids);
    setNotes();
    update();
  }

  Future<void> undoSave() async {
    final db = await database();

    await db.delete(
      'notes',
      where: 'id = (SELECT MAX(id) FROM notes)',
    );
  }

  void goToMain(BuildContext context) {
    selectedNotes.value = [];

    update();
    Get.offAll(MainScreen());
  }

  Future<void> deleteNote(int id) async {
    final db = await database();

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    update();
  }

// ****************************************************************
// selectedNotes methods
  void clearBatch() {
    selectedNotes.value = [];
    update();
  }

  void toggleSelect() {
    if (selectedNotes.isEmpty) {
      hasSelect.value = false;
    }
    update();
  }

  void updateSelectedNotes(int index) {
    if (selectedNotes.contains(notes[index].id as int)) {
      selectedNotes.remove(notes[index].id as int);
      update();
      // notesController.selectedNotes.refresh();
    } else {
      selectedNotes.add(notes[index].id as int);
      update();
    }
  }
}
