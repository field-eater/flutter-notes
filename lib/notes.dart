import 'package:PHNotes/screens/create_note_screen.dart';
import 'package:PHNotes/screens/view_note_screen.dart';
import 'package:flutter/material.dart';

import 'package:PHNotes/screens/main_screen.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //   routes: {
      //   '/': (context) => const MainScreen(),
      //   '/view': (context) => const ViewNoteScreen(note: ,),
      //   '/create': (context) =>  CreateNoteScreen(),
      // },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.deepPurple,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
