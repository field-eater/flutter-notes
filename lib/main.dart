import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/notes.dart';
import 'package:notes_app/services/notes_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  await database();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NotesController()),
    ],
    child: const Notes(),
  ));
}
