import 'package:flutter/widgets.dart';

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
      return _createDb(db, version);
    },
    version: 1,
    // onUpgrade: (Database db, int ol)
  );

  return database;
}

void _createDb(Database db, int newVersion) async {
  await db.execute(
    'CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL); ',
  );
  await db.execute(
      'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL,  created_at DATETIME, updated_at DATETIME, category_id INTEGER,  FOREIGN KEY (category_id) REFERENCES categories(id));');
  initializeCategories();
}

void initializeCategories() async {
  final db = await database();
  final batch = db.batch();
  final initialCategories = {
    {'title': 'All'},
    {'title': 'Personal'},
    {'title': 'Work'},
    {'title': 'Family'},
    {'title': 'Others'},
  };

  for (final category in initialCategories) {
    batch.insert('categories', category);
  }
  await batch.commit(noResult: true);
}
