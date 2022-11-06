import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const FrontPage(),
    );
  }
}
