import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/editPlanDlg.dart';
import 'package:planner/src/planner/planItemListController.dart';

class PlanListPage extends StatefulWidget {
  const PlanListPage({Key? key}) : super(key: key);

  @override
  State<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends State<PlanListPage> {
  final ItemListController _conItemList = Get.find();

  void updateWidgetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _conItemList.getPlanListItemWidgets( updateWidgetState );

    return GetBuilder<ItemListController>(
      init: _conItemList,
      builder: (controller) => Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              pinned: true,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Ваши планы:'),
                background: FlutterLogo(),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Center(
                  child: Text(
                    'всего: ${_conItemList.itemListItemModel.length}',
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
