import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import '../../constants.dart';
import 'curr_plan_tree_comp.dart';

class CurrentPlanPage extends StatelessWidget {
  const CurrentPlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlanController planController = Get.find();

    return Scaffold(
      backgroundColor: DEFAULT_SCAFFOLD_BACKGROUND,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        TITLE_CURRENT_PLAN,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Obx(
                      () => Text(
                        planController.currentActivePlanName,
                        style: const TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ],
              )),
          Expanded(
              flex: 6,
              child: Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 1300),
                child: const CurrentPlanTree(),
              ))
        ],
      ),
    );
  }
}
