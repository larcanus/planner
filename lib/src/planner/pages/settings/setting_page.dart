import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';

import '../../constants.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final PlanController planController = Get.find();
    var switchValue = planController.settings['isShowButtonsScale'] ??= false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 1,
      ),
      body: Scrollbar(
        child: ListView(
          restorationId: 'list_view_setting',
          padding: const EdgeInsets.all(10.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(SETTING_SCALE_BUTTONS),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    print('$value');
                    switchValue = value;
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:   [
                Text(SETTING_VERSION),
                Text( planController.packageInfo.version ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
