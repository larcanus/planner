import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/currentPlanPage.dart';
import 'package:planner/src/planner/planItemListController.dart';
import 'package:planner/src/planner/planListPage.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final ItemListController _ctrlItemList = Get.put(ItemListController());

  @override
  initState() {
    super.initState();
    _ctrlItemList.loadPlanItemModels();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const CurrentPlanPage(),
    const PlanListPage(),
    const Text(
      'Settings',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  var bottomNavigationBarItems = <BottomNavigationBarItem>[
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () => Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_ctrlItemList.selectedTab),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: true,
          items: bottomNavigationBarItems,
          currentIndex: _ctrlItemList.selectedTab,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            _ctrlItemList.selectedTab = index;
          },
          selectedItemColor: colorScheme.onPrimary,
          unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
          backgroundColor: colorScheme.primary,
        ),
      ),
    );
  }
}
