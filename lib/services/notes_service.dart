import 'package:flutter/widgets.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'notes.db'),

    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT, date DATETIME)',
      );
    },
    version: 1,
  );

  return database;
}
