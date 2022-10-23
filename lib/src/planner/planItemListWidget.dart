import 'package:flutter/material.dart';
import 'builderPage.dart';
import 'confirmDlg.dart';
import 'constants.dart';
import 'editPlanDlg.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/planItemListController.dart';

class PlanItemListWidget extends StatelessWidget {
  final Function updateWidgetState;
  final int id;
  final String planeName;
  final String planeDesc;
  final int backgroundColor;
  final bool isActive;

  const PlanItemListWidget(
      {required this.updateWidgetState,
      required this.id,
      required this.planeName,
      required this.planeDesc,
      required this.backgroundColor,
      required this.isActive,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemListController contItemList = Get.find();
    final gradientColor = COLORS_GRADIENT[backgroundColor] ??
        [
          const Color(0xffb599d6),
          const Color(0xffb599d6),
          const Color(0xffc4ade6),
        ];

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 15, 0),
                    child: DefaultTextStyle(
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(planeName),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: PopupMenuButton<String>(
                    padding: const EdgeInsets.only(top: 6),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Future resultDlg = showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditPlanDialog(
                              key: UniqueKey(),
                              title: planeName,
                              description: planeDesc,
                              id: id,
                            );
                          },
                        );
                        dynamic result = await resultDlg;
                        if (result == true) {
                          updateWidgetState();
                        }
                      } else {
                        Future resultDlg = showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDlg(
                              key: UniqueKey(),
                              title: 'Предупреждение',
                              description:
                                  'Вы действительно хотите удалить этот план?',
                            );
                          },
                        );

                        dynamic result = await resultDlg;
                        if (result == true) {
                          contItemList.deleteItemListById(id);
                          updateWidgetState();
                        }
                      }
                    },
                    itemBuilder: (context) => <PopupMenuItem<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Редактировать',
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'remove',
                        child: Text(
                          'Удалить',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
              child: DefaultTextStyle(
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: const TextStyle(color: Colors.black54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(planeDesc),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    contItemList.activateItemPlanById(id);
                    updateWidgetState();
                  },
                  child: isActive
                      ? const Text('Активен')
                      : const Text('Активировать'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuilderPage(  selectPlanId: id )
                      ),
                    );
                  },
                  child: const Text(
                    'Строить',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
