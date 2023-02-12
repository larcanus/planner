import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/state_manager/plan_controller.dart';

import '../../constants.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlanController planController = Get.find();
    return Scaffold(
      backgroundColor: DEFAULT_SCAFFOLD_BACKGROUND,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 1,
      ),
      body: Scrollbar(
        child: Obx(
          () => ListView(
            restorationId: 'list_view_setting',
            padding: const EdgeInsets.all(10.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(SETTING_SCALE_BUTTONS),
                  Switch(
                    value: planController.settings['isShowButtonsScale'],
                    onChanged: (value) {
                      print('$value');
                      planController.settings['isShowButtonsScale'] = value;
                      planController.updateUserSettingsData();
                    },
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(SETTING_VERSION),
                  Text(planController.packageInfo.version),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
