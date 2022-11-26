import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/pages/builder/builder_page.dart';
import 'package:planner/src/planner/pages/plans_list/plan_item_list_widget.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';
import 'package:planner/src/planner/state_manager/plan_tree_model.dart';
import '../constants.dart';
import '../file_manager.dart';

class PlanController extends GetxController {
  var _selectedTab = 0.obs;
  var _itemListItemModel = <PlanItemListModel>[].obs;
  var _itemListWidgets = <Widget>[].obs;
  var _currentActiveModel = null;
  var _currentActiveModelName = 'Нет активного плана'.obs;
  var _selectedStepTools = null;
  var _selectedStep = null;
  var _selectedPlan = null;
  var _componentsInGame = [];

  get selectedTab => _selectedTab.value;

  set selectedTab(index) => _selectedTab.value = index;

  List<PlanItemListModel> get itemListItemModel => _itemListItemModel.value;

  List<Widget> get itemListWidgets => _itemListWidgets;

  get currentActiveModel => _currentActiveModel;

  set currentActiveModel(model) => _currentActiveModel = model;

  get currentActiveModelName => _currentActiveModelName.value;

  set currentActiveModelName(name) => _currentActiveModelName.value = name;

  get selectedStepTools => _selectedStepTools;

  set selectedStepTools(stepTools) => _selectedStepTools = stepTools;

  get selectedStep => _selectedStep;

  set selectedStep(step) => _selectedStep = step;

  get componentsInGame => _componentsInGame;

  get selectedPlan => _selectedPlan;

  set selectedPlan(plan) => _selectedPlan = plan;

  void loadPlanItemModels() async {
    _itemListItemModel.clear();

    List<dynamic> eternalDataPLan = await getUserData();
    // вариант загрузки руками без хранилища
    // List<PlanItemListModel> eternalDataPLan = [
    //   PlanItemListModel(
    //       id: UniqueKey().hashCode,
    //       planeName: '123456789012345678901234567890',
    //       planeDesc: 'test22222 22222222 22222222222 22222',
    //       backgroundColor: 0xff2980b9),
    //   PlanItemListModel(
    //     id: UniqueKey().hashCode,
    //     planeName: '123456789012345678901234567890',
    //     planeDesc: 'test22222 22222222 22222222222 22222',
    //     backgroundColor: 0xff2980b9,
    //     isActive: false,
    //   )
    // ];

    for (int i = 0; i < eternalDataPLan.length; i++) {
      final item = eternalDataPLan[i];
      PlanTreeModel tree = getTreeStructureFromJson(item['tree']);

      final planItemModel = PlanItemListModel(
          id: item['id'],
          planeName: item['planeName'],
          planeDesc: item['planeName'],
          backgroundColor: item['backgroundColor'],
          isActive: item['isActive'],
          tree: tree);
      _itemListItemModel.add(planItemModel);
      if (item['isActive']) {
        currentActiveModel = planItemModel;
        currentActiveModelName = planItemModel.planeName;
      }
    }
    update();
  }

  getTreeStructureFromJson(stepData) {
    PlanTreeModel step = PlanTreeModel(
      id: stepData['id'],
      name: stepData['name'],
      parentId: stepData['parentId'],
      width: stepData['width'],
      height: stepData['height'],
      type: stepData['type'],
      gPosition: stepData['gPosition'].cast<String, double>(),
      childs: [],
    );

    if (stepData['childs'].isNotEmpty) {
      stepData['childs'].forEach((child) {
        step.childs.add(getTreeStructureFromJson(child));
      });
    }
    return step;
  }

  updateUserData() {
    createUserData(itemListItemModel);
  }

  getPlanListItemWidgets(void Function() updateWidgetState) {
    _itemListWidgets.clear();

    for (int i = 0; i < itemListItemModel.length; i++) {
      var itemData = itemListItemModel[i];
      _itemListWidgets.add(PlanItemListWidget(
          updateWidgetState: updateWidgetState,
          id: itemData.id,
          planeName: itemData.planeName,
          planeDesc: itemData.planeDesc,
          backgroundColor: itemData.backgroundColor,
          isActive: itemData.isActive));
    }
    update();
  }

  addItemList(dataName, dataDesc, dataBackgroundColor) {
    itemListItemModel.add(PlanItemListModel(
        id: UniqueKey().hashCode,
        planeName: dataName,
        planeDesc: dataDesc,
        backgroundColor: dataBackgroundColor,
        tree: PlanTreeModel(
          id: UniqueKey().hashCode,
          name: NAME_ROOT_STEP,
          parentId: 0,
          width: 140,
          height: 100,
          type: STEP_TYPE_RECT,
          gPosition: {'x': 0.0, 'y': 0.0},
          childs: [],
        )));
    updateUserData();
    update();
  }

  void updateItemListById(id, dataName, dataDesc, dataBackgroundColor) {
    for (int i = 0; i < itemListItemModel.length; i++) {
      var itemData = itemListItemModel[i];
      if (itemData.id == id) {
        itemData.planeName = dataName;
        itemData.planeDesc = dataDesc;
        itemData.backgroundColor = dataBackgroundColor;
        break;
      }
    }
    updateUserData();
    update();
  }

  void deleteItemListById(id) {
    itemListItemModel.removeWhere((model) => model.id == id);
    updateUserData();
    update();
  }

  void activateItemPlanById(id) {
    for (int i = 0; i < itemListItemModel.length; i++) {
      var itemData = itemListItemModel[i];
      if (itemData.id == id) {
        itemData.isActive = true;
        currentActiveModelName = itemData.planeName;
      } else {
        itemData.isActive = false;
      }
    }
    updateUserData();
    update();
  }

  PlanItemListModel getItemPlanById(id) {
    for (int i = 0; i < itemListItemModel.length; i++) {
      var itemData = itemListItemModel[i];
      if (itemData.id == id) {
        return itemData;
      }
    }
    return currentActiveModel;
  }

  getStepById(int id) {
    var plan = selectedPlan;
    var rootStep = plan.tree;

    recursiveFind(step) {
      if (step.id == id) {
        return step;
      }
      for (int i = 0; i < step.childs.length; i++) {
        PlanTreeModel child = step.childs[i];
        if (child.id == id) {
          return child;
        }
        recursiveFind(child);
      }
    }

    return recursiveFind(rootStep);
  }

  addStep(dataName, dataDesc, dataBackgroundColor, {type = STEP_TYPE_RECT}) {
    int stepId = selectedStep.id;
    var step = getStepById(stepId);
    var stepPos = getPositionNewStep(step);

    var stepNew = PlanTreeModel(
      id: UniqueKey().hashCode,
      name: dataName,
      parentId: step.id,
      gPosition: stepPos,
      // {'x': 0, 'y': 80},
      width: 140,
      height: 100,
      type: type,
      childs: [],
    );

    step.childs.add(stepNew);
    updateUserData();
    update();
  }

  getPositionNewStep(PlanTreeModel parentStep) {
    var pos = {'x': 150.0, 'y': -50.0};

    if (parentStep.childs.isNotEmpty) {
      int countStep = parentStep.childs.length;
      switch (countStep) {
        case 1:
          parentStep.childs[0].gPosition = {'x': 150.0, 'y': -130.0};
          pos = {'x': 150.0, 'y': 30.0};
          break;
        case 2:
          parentStep.childs[0].gPosition = {'x': 150.0, 'y': -180.0};
          parentStep.childs[1].gPosition = {'x': 150.0, 'y': -50.0};
          pos = {'x': 150.0, 'y': 80.0};
          break;
        case 3:
          parentStep.childs[0].gPosition = {'x': 150.0, 'y': -250.0};
          parentStep.childs[1].gPosition = {'x': 150.0, 'y': -120.0};
          parentStep.childs[2].gPosition = {'x': 150.0, 'y': 10.0};
          pos = {'x': 150.0, 'y': 140.0};
          break;
      }
    }

    return pos;
  }
}
