import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';

class CurrentPlanPage extends StatefulWidget {
  const CurrentPlanPage({Key? key}) : super(key: key);

  @override
  State<CurrentPlanPage> createState() => _CurrentPlanPageState();
}

class _CurrentPlanPageState extends State<CurrentPlanPage> {
  final PlanController _conItemList = Get.find();

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Текущий план: ',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Obx(
            () => Text(
              _conItemList.currentActiveModelName,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
