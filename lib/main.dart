import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planner v1.0.0',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const FrontPage(),
    );
  }
}
