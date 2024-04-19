import 'package:flutter/material.dart';
import 'package:PHNotes/controllers/note_controller.dart';
import 'package:PHNotes/notes.dart';
import 'package:PHNotes/services/notes_service.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  await database();
  runApp(
    const Notes(),
  );
}
