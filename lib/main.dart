import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'app.dart';

void main() async {
  PlanController planController = Get.put(PlanController());
  await planController.loadPlanItemModels();
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
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFF459D3E),
              onPrimary: Color(0xFFFFFFFF),
              secondary: Color(0xFF459D3E),
              onSecondary: Color(0xFFFFFFFF),
              background: Color(0xFFFFFFFF),
              onBackground: Colors.black,
              surface: Colors.green,
              onSurface: Colors.white,
              error: Colors.red,
              onError: Colors.black)),
      home: const FrontPage(),
    );
  }
}
