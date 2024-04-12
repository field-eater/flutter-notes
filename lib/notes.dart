import 'package:flutter/material.dart';
import 'package:notes_app/screens/create_notes_screen.dart';
import 'package:notes_app/screens/main_screen.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
