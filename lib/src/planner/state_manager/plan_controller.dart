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
      final planItemModel = PlanItemListModel(
        id: item['id'],
        planeName: item['planeName'],
        planeDesc: item['planeName'],
        backgroundColor: item['backgroundColor'],
        isActive: item['isActive'],
        tree: PlanTreeModel(
          id: item['tree']['id'],
          name: item['tree']['name'],
          parentId: item['tree']['parentId'],
          width :  item['tree']['width'],
          height :  item['tree']['height'],
          isCircle :  item['tree']['isCircle'],
          gPosition: item['tree']['gPosition'],
          childs: item['tree']['childs'],
        ),
      );
      _itemListItemModel.add(planItemModel);
      if (item['isActive']) {
        currentActiveModel = planItemModel;
        currentActiveModelName = planItemModel.planeName;
      }
    }
    update();
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
          parentId: null,
          width : 100,
          height : 125,
          isCircle : false,
          gPosition: {'x': 0, 'y': 0},
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
}
