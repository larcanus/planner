import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/pages/cur_plan/current_plan_page.dart';
import 'package:planner/src/planner/pages/settings/setting_page.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';
import 'package:planner/src/planner/pages/plans_list/plan_list_page.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    PlanController planController = Get.find();

    List<BottomNavigationBarItem> bottomNavigationBarItems =
    <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.directions_walk),
        label: 'Текущий шаг',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_tree_outlined),
        label: 'Планнер',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Настройки',
        tooltip: 'tooltip',
      ),
    ];

    List<Widget> pages = <Widget>[
      const CurrentPlanPage(),
      const PlanListPage(),
      const SettingPage(),
    ];

    return Obx(
      () => Scaffold(
        body: Center(
          child: pages.elementAt(planController.selectedTab),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: true,
          items: bottomNavigationBarItems,
          currentIndex: planController.selectedTab,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            planController.selectedTab = index;
          },
          selectedItemColor: colorScheme.onPrimary,
          unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
          backgroundColor: colorScheme.primary,
        ),
      ),
    );
  }
}
