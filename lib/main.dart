import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const CreativeFlowApp());
}

class CreativeFlowApp extends StatelessWidget {
  const CreativeFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreativeFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
