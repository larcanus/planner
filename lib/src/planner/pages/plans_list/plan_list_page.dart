import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/pages/plans_list/edit_plan_dlg.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';

import '../../constants.dart';

class PlanListPage extends StatefulWidget {
  const PlanListPage({Key? key}) : super(key: key);

  @override
  State<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends State<PlanListPage> {
  final PlanController _conItemList = Get.find();

  void updateWidgetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _conItemList.getPlanListItemWidgets( updateWidgetState );

    return GetBuilder<PlanController>(
      init: _conItemList,
      builder: (controller) => Scaffold(
        backgroundColor: DEFAULT_SCAFFOLD_BACKGROUND,
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              pinned: true,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(SLIVER_APP_BAR_TITLE),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Center(
                  child: Text(
                    '$SLIVER_ADAPTER_TITLE ${_conItemList.planItemListModels.length}',
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [..._conItemList.itemListWidgets, const SizedBox(height: 80)]);
                },
                childCount: 1,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_outlined),
          onPressed: () async {
            Future resultDlg = showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditPlanDialog(
                    key: UniqueKey(),
                  );
                });

            dynamic result = await resultDlg;
            if (result == true) {
              updateWidgetState();
            }
          },
        ),
      ),
    );
  }
}
