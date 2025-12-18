import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/providers.dart';
import 'core/navigation.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FitnessProvider(),
      child: MaterialApp(
        title: 'Fitness Tracker',
        theme: FitnessTheme.lightTheme,
        darkTheme: FitnessTheme.darkTheme,
        home: const AppShell(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
