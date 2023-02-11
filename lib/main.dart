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
        primarySwatch: Colors.indigo,
      ),
      home: const FrontPage(),
    );
  }
}
