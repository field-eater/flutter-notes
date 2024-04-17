import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/screens/main_screen.dart';
import 'package:notes_app/services/notes_service.dart';
import 'package:sqflite/sqflite.dart';

class NotesController extends ChangeNotifier {
  TextEditingController formController = TextEditingController();
  StreamController noteStreamController = StreamController();

  List<int> _selectedNotes = [];
  List<int> get selectedNotes => _selectedNotes;

  set selectedNotes(List<int> value) {
    if (value.isNotEmpty) {
      _selectedNotes = value;
    }
  }

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
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  void goToMain(BuildContext context) {
    _selectedNotes = [];
    ;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    final db = await database();

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> deleteNotes(List<int> ids) async {
    final db = await database();
    for (int id in ids) {
      await db.delete('notes',
          where: 'id IN (${List.filled(ids.length, '?').join(',')})',
          whereArgs: ids);
    }
    notifyListeners();
  }

  Future<void> undoSave() async {
    final db = await database();

    await db.delete(
      'notes',
      where: 'id = (SELECT MAX(id) FROM notes)',
    );
    notifyListeners();
  }
}
