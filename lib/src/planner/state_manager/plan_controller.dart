import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/src/planner/pages/plans_list/plan_item_list_widget.dart';
import 'package:planner/src/planner/state_manager/plan_item_list_model.dart';
import 'package:planner/src/planner/state_manager/step_model.dart';
import 'package:planner/src/planner/utils.dart';
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
  var _selectedStepModel = null;
  var _selectedPlan = null;
  var _componentsInGame = [];

  late Vector2 _canvasSizeDefault;

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

  get selectedStepModel => _selectedStepModel;

  set selectedStepModel(step) => _selectedStepModel = step;

  get componentsInGame => _componentsInGame;

  get selectedPlan => _selectedPlan;

  set selectedPlan(plan) => _selectedPlan = plan;

  get canvasSizeDefault => _canvasSizeDefault;

  set canvasSizeDefault(size) => _canvasSizeDefault = size;

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
      StepModel tree = getTreeStructureFromJson(item['tree']);

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
    StepModel step = StepModel(
      id: stepData['id'],
      name: stepData['name'],
      description: stepData['description'],
      background: stepData['background'],
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
        tree: StepModel(
          id: UniqueKey().hashCode,
          name: NAME_ROOT_STEP,
          description: '',
          background: DEFAULT_BACKGROUND_STEP.toHex(),
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
    PlanItemListModel plan = selectedPlan;
    StepModel rootStep = plan.tree;
    var findChild;

    recursiveFind(step) {
      if (step.id == id) {
        findChild = step;
      }
      for (int i = 0; i < step.childs.length; i++) {
        StepModel child = step.childs[i];
        if (child.id == id) {
          findChild = child;
          break;
        } else {
          recursiveFind(child);
        }
      }
    }

    recursiveFind(rootStep);
    return findChild;
  }

  deleteStepByIdFromTree({id}) {
    int idStep = id ?? selectedStepModel.id;
    PlanItemListModel plan = selectedPlan;
    StepModel rootStep = plan.tree;

    recursiveFind(step) {
      for (int i = 0; i < step.childs.length; i++) {
        StepModel child = step.childs[i];
        if (child.id == idStep) {
          step.childs.removeAt(i);
          break;
        } else {
          recursiveFind(child);
        }
      }
    }

    recursiveFind(rootStep);
    updateUserData();
    update();
  }

  addStep(dataName, dataDesc, dataBackgroundColor, {type = STEP_TYPE_RECT}) {
    int stepId = selectedStep.id;
    var step = getStepById(stepId);
    if (step != null) {
      var stepPos = getPositionNewStep(step);

      var stepNew = StepModel(
        id: UniqueKey().hashCode,
        name: dataName,
        description: dataDesc,
        background: dataBackgroundColor,
        parentId: step.id,
        gPosition: stepPos,
        width: 140,
        height: 100,
        type: type,
        childs: [],
      );

      step.childs.add(stepNew);
      selectedStepModel = stepNew;
      rebuildPositionBtStep(stepNew);
      updateUserData();
      update();
    }
  }

  updateStepById(id, dataName, dataDesc, dataBackgroundColor,
      {type = STEP_TYPE_RECT}) {
    var step = getStepById(id);
    if (step != null) {
      step
        ..name = dataName
        ..description = dataDesc
        ..background = dataBackgroundColor;
      updateUserData();
      update();
    }
  }

  getPositionNewStep(parentStep) {
    var parentPos = parentStep.gPosition;
    var pos = {'x': 150.0, 'y': -50.0};
    bool isRoot = parentPos['x'] == 0.0 && parentPos['y'] == 0.0;
    if (parentPos['x'] != null && !isRoot) {
      pos['x'] = pos['x']! + parentPos['x'] + 70.0;
      pos['y'] = parentPos['y'];
    }

    if (parentStep.childs.isNotEmpty) {
      int countStep = parentStep.childs.length;
      switch (countStep) {
        case 1:
          if (isRoot) {
            parentStep.childs[0].gPosition = {'x': pos['x'], 'y': -130.0};
            pos['y'] = 30.0;
          } else {
            parentStep.childs[0].gPosition = {
              'x': pos['x'],
              'y': pos['y']! + (-80.0)
            };
            pos['y'] = parentPos['y']! + 80.0;
          }
          break;
        case 2:
          if (isRoot) {
            parentStep.childs[0].gPosition = {'x': pos['x'], 'y': -180.0};
            parentStep.childs[1].gPosition = {'x': pos['x'], 'y': -50.0};
            pos['y'] = 80.0;
          } else {
            parentStep.childs[0].gPosition = {
              'x': pos['x'],
              'y': parentPos['y']! + (-130.0)
            };
            parentStep.childs[1].gPosition = {
              'x': pos['x'],
              'y': parentPos['y']
            };
            pos['y'] = parentPos['y']! + 130.0;
          }
          break;
        case 3:
          if (isRoot) {
            parentStep.childs[0].gPosition = {'x': pos['x'], 'y': -250.0};
            parentStep.childs[1].gPosition = {'x': pos['x'], 'y': -120.0};
            parentStep.childs[2].gPosition = {'x': pos['x'], 'y': 10.0};
            pos['y'] = 140.0;
          } else {
            parentStep.childs[0].gPosition = {
              'x': pos['x'],
              'y': parentPos['y']! + (-195.0)
            };
            parentStep.childs[1].gPosition = {
              'x': pos['x'],
              'y': parentPos['y']! + (-65.0)
            };
            parentStep.childs[2].gPosition = {
              'x': pos['x'],
              'y': parentPos['y']! + 65
            };
            pos['y'] = parentPos['y']! + 195.0;
          }
          break;
      }
    }
    return pos;
  }

  selectStepById({id}) {
    int idStep = id ?? selectedStepModel.id;
    componentsInGame.forEach((comp) {
      if (comp.toString() == 'Step' && comp.id == idStep) {
        comp.selectStep();
        comp.handlerButtonsStep();
      }
    });
  }

  deleteStepByIdFromComponentsCash({id}) {
    int idStep = id ?? selectedStepModel.id;
    componentsInGame
        .removeWhere((comp) => comp.toString() == 'Step' && comp.id == idStep);
    update();
  }

  rebuildPositionBtStep(StepModel step) {
    List<StepModel> stepsLine = getVerticalLineStepsByX(step.gPosition['x']);

    var isHasIntersection = isIntersectionInLineX(stepsLine);
    if (isHasIntersection) {
      var parent = getStepById(step.parentId);
      List<StepModel> stepsLineParent =
          getVerticalLineStepsByX(parent.gPosition['x']);

      var parentParent = getStepById(parent.parentId);
      List<StepModel> stepsLineParentParent =
          getVerticalLineStepsByX(parentParent.gPosition['x']);
      setSpreadStepsLineParent(stepsLineParentParent, parent);

      for (var stepParentParent in stepsLineParentParent) {
        setPositionChildByParent(stepParentParent);
      }
      for (var stepParent in stepsLineParent) {
        setPositionChildByParent(stepParent);
      }
      for (var step in stepsLine) {
        setPositionChildByParent(step);
      }
    }

    if (isIntersectionInLineX(stepsLine)) {
      rebuildPositionBtStep(step);
    }
  }

  List<StepModel> getVerticalLineStepsByX(double posX) {
    PlanItemListModel plan = selectedPlan;
    StepModel rootStep = plan.tree;
    List<StepModel> findSteps = [];

    recursiveFind(step) {
      if (step.gPosition['x'] == posX) {
        findSteps.add(step);
      }
      for (int i = 0; i < step.childs.length; i++) {
        StepModel child = step.childs[i];
        recursiveFind(child);
      }
    }

    recursiveFind(rootStep);
    return findSteps;
  }

  bool isIntersectionInLineX(List<StepModel> stepsLine) {
    bool isHasIntersection = false;
    List listPos = [];
    for (var step in stepsLine) {
      double stepPosY = step.gPosition['y'];
      for (var pos in listPos) {
        if (pos == stepPosY) {
          isHasIntersection = true;
        } else {
          var posA = pos > stepPosY ? pos : stepPosY;
          var posB = pos < stepPosY ? pos : stepPosY;

          var distance = posA - posB;
          if (distance < 130) {
            isHasIntersection = true;
          }
        }
      }
      listPos.add(stepPosY);
    }
    // print(isHasIntersection);
    return isHasIntersection;
  }

  setSpreadStepsLineParent(stepLine, editableStep) {
    for (var step in stepLine) {
      var childs = step.childs;
      if (childs.isNotEmpty) {
        int editableChildIndex =
            childs.indexWhere((child) => child.id == editableStep.id);
        print(editableChildIndex);
        if (editableChildIndex != -1) {
          spreadChildsByOneStep(childs,editableChildIndex);
        } else {
          var parent = getStepById(step.parentId);
          var index = parent.childs.indexWhere((child) => child.id == step.id);
          spreadChildsByOneStep(parent.childs, index);
        }
      }
    }
  }

  spreadChildsByOneStep(childs, index){
    int countStep = childs.length;
    switch (countStep) {
      case 2:
        childs[0].gPosition['y'] = childs[0].gPosition['y'] + (-5.0);
        childs[1].gPosition['y'] = childs[1].gPosition['y'] + 5.0;
        break;
      case 3:
        if (index == 0) {
          childs[0].gPosition['y'] = childs[0].gPosition['y'] + (-10.0);
          childs[1].gPosition['y'] = childs[1].gPosition['y'];
          childs[2].gPosition['y'] = childs[2].gPosition['y'];
        } else if (index == 1) {
          childs[0].gPosition['y'] = childs[0].gPosition['y'] + (-5.0);
          childs[1].gPosition['y'] = childs[1].gPosition['y'];
          childs[2].gPosition['y'] = childs[2].gPosition['y'] + 5.0;
        } else {
          childs[0].gPosition['y'] = childs[0].gPosition['y'];
          childs[1].gPosition['y'] = childs[1].gPosition['y'];
          childs[2].gPosition['y'] = childs[2].gPosition['y'] + 10.0;
        }
        break;
      case 4:
        if (index == 0) {
          childs[0].gPosition['y'] = childs[0].gPosition['y'] + (-5.0);
          childs[1].gPosition['y'] = childs[1].gPosition['y'];
          childs[2].gPosition['y'] = childs[2].gPosition['y'];
          childs[3].gPosition['y'] = childs[3].gPosition['y'];
        } else if (index == 1) {
          childs[0].gPosition['y'] = childs[0].gPosition['y'] + (-10.0);
          childs[1].gPosition['y'] = childs[1].gPosition['y'] + (-5.0);
          childs[2].gPosition['y'] = childs[2].gPosition['y'];
          childs[3].gPosition['y'] = childs[3].gPosition['y'];
        } else if (index == 2) {
          childs[0].gPosition['y'] = childs[0].gPosition['y'];
          childs[1].gPosition['y'] = childs[1].gPosition['y'];
          childs[2].gPosition['y'] = childs[2].gPosition['y'] + 5.0;
          childs[3].gPosition['y'] = childs[3].gPosition['y'] + 10.0;
        } else {
          childs[0].gPosition['y'] = childs[0].gPosition['y'];
          childs[1].gPosition['y'] = childs[1].gPosition['y'];
          childs[2].gPosition['y'] = childs[2].gPosition['y'];
          childs[3].gPosition['y'] = childs[3].gPosition['y'] + 5.0;
        }
        break;
    }
  }

  setPositionChildByParent(StepModel step) {
    var parentPos = step.gPosition;
    var pos = {'x': 150.0, 'y': -50.0};
    var childs = step.childs;
    if (parentPos['x'] != null) {
      pos['x'] = pos['x']! + parentPos['x'] + 70.0;
      pos['y'] = parentPos['y'];
    }
    if (childs.isNotEmpty) {
      int countStep = childs.length;
      switch (countStep) {
        case 1:
          childs[0].gPosition = {'x': pos['x'], 'y': pos['y']!};
          break;

        case 2:
          childs[0].gPosition = {'x': pos['x'], 'y': pos['y']! + (-80.0)};
          childs[1].gPosition = {
            'x': pos['x'],
            'y': parentPos['y']! + 80.0,
          };
          break;
        case 3:
          childs[0].gPosition = {'x': pos['x'], 'y': pos['y']! + (-130.0)};
          childs[1].gPosition = {
            'x': pos['x'],
            'y': parentPos['y'],
          };
          childs[2].gPosition = {
            'x': pos['x'],
            'y': parentPos['y']! + 130.0,
          };
          break;
        case 4:
          childs[0].gPosition = {'x': pos['x'], 'y': pos['y']! + (-195.0)};
          childs[1].gPosition = {
            'x': pos['x'],
            'y': parentPos['y']! + (-65.0),
          };
          childs[2].gPosition = {
            'x': pos['x'],
            'y': parentPos['y']! + 65,
          };
          childs[3].gPosition = {
            'x': pos['x'],
            'y': parentPos['y']! + 195.0,
          };
          break;
      }
    }
  }
}
