import 'package:flutter/material.dart';

import 'package:PHNotes/screens/main_screen.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
