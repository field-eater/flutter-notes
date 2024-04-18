import 'package:PHNotes/screens/create_note_screen.dart';
import 'package:PHNotes/screens/view_note_screen.dart';
import 'package:flutter/material.dart';

import 'package:PHNotes/screens/main_screen.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  static const Color tailwindBlueLight = Color.fromRGBO(59, 130, 246, 1);
  static const Color tailwindBlueDark = Color.fromRGBO(23, 37, 84, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: tailwindBlueLight,

        iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
          iconColor: MaterialStatePropertyAll<Color>(Colors.white),
          backgroundColor: MaterialStatePropertyAll<Color>(tailwindBlueLight),
        )),

        // Light mode theme properties
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleMedium: TextStyle(color: Colors.black54), // Subtext color
        ),
        cardColor: Colors.white, // Card color
        buttonTheme: const ButtonThemeData(
          buttonColor: tailwindBlueLight,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Dark mode theme properties
        primaryColor: tailwindBlueDark,
        iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
          iconColor: MaterialStatePropertyAll<Color>(Colors.white),
          backgroundColor: MaterialStatePropertyAll<Color>(tailwindBlueDark),
        )),

        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white70), // Subtext color
        ),
        cardColor: Colors.grey[800], // Dark card color
        buttonTheme: const ButtonThemeData(
          buttonColor: tailwindBlueDark,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
