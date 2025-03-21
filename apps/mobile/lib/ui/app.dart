import 'package:flutter/material.dart';

import 'screens/main_screen.dart';

class PomoApp extends StatelessWidget {
  const PomoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Jersery15',
    );
    return MaterialApp(
      title: 'Pomo',
      theme: theme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
