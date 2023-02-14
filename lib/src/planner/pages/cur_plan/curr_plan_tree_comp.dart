import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:planner/src/planner/state_manager/step_model.dart';

import '../../constants.dart';
import '../../flame_componets/step_line.dart';
import '../../flame_componets/step_rectangle.dart';
import '../../flame_componets/step_text_box.dart';
import '../../state_manager/plan_controller.dart';
import '../../state_manager/plan_item_list_model.dart';
import '../../utils.dart';

class CurrentPlanTree extends StatelessWidget {
  const CurrentPlanTree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlanController planController = Get.find();
    return GameWidget(game: TreeActiveStep(), overlayBuilderMap: {
      'buttonActivate': (BuildContext context, TreeActiveStep game) {
        return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              margin: const EdgeInsets.all(23),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        planController.setActiveStepBySelectStep();
                        game.refreshTree();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 12.0,
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: COLOR_BUTTON_ACTIVATE,
                      ),
                      child: const Text(TITLE_BUTTON_ACTIVE),
                    ),
                  ]))
        ]);
      },
      'stepInfo': (BuildContext context, TreeActiveStep game) {
        String name = planController.selectedStepModel.name;
        String desc = planController.selectedStepModel.description != ''
            ? planController.selectedStepModel.description
            : DEFAULT_STEP_INFO_DESC;
        String background = planController.selectedStepModel.background ??
            DEFAULT_COLOR_BACKGROUND_STEP_INFO;
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.all(23),
              padding: const EdgeInsets.all(10),
              width: 160,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: COLOR_BORDER_STEP_INFO,
                  ),
                  color: HexColor.fromHex(background),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  Text(desc,
                      overflow: TextOverflow.clip, textAlign: TextAlign.start)
                ],
              ),
            )
          ])
        ]);
      }
    });
  }
}

class TreeActiveStep extends FlameGame with HasTappables {
  final PlanController planController = Get.find();

  @override
  Color backgroundColor() => DEFAULT_BACKGROUND_BUILDER_FRONT_PAGE;

  @override
  Future<void> onLoad() async {
    buildTree();
  }

  @override
  Future<void> onMount() async {}

  void buildTree() {
    var activePlan = planController.currentActivePlan;
    if (activePlan != null) {
      var activeStep = getActiveStep(activePlan);
      if (activeStep != null) {
        planController.componentsInGame = [];
        drawActiveStep(activeStep);
        drawLastSteps(getLastSteps(activeStep));
        drawNextSteps(getNextSteps(activeStep));
      } else {
        Plug();
      }
    } else {
      Plug();
    }
  }

  void refreshTree() {
    var allComponents = planController.componentsInGame;
    allComponents.forEach((comp) {
      comp.removeFromParent();
    });
    if (overlays.isActive('buttonActivate')) {
      overlays.remove('buttonActivate');
    }
    buildTree();
  }

  dynamic getActiveStep(PlanItemListModel tree) {
    return planController.getStepById(tree.activeStep, fromActivePlan: true);
  }

  void drawActiveStep(StepModel activeStep) {
    Vector2 centerPos = Vector2(canvasSize.x / 2, canvasSize.y / 2);

    if (activeStep.type == STEP_TYPE_RECT) {
      centerPos = Vector2(
          canvasSize.x / 2 - activeStep.width / 2 / STEP_DECREASE_ACTIVE_COF,
          canvasSize.y / 2 - activeStep.height / 2 / STEP_DECREASE_ACTIVE_COF);
    }

    StepRectangleFrontPage step = StepRectangleFrontPage(
      id: activeStep.id,
      squareWidth: activeStep.width / STEP_DECREASE_ACTIVE_COF,
      squareHeight: activeStep.height / STEP_DECREASE_ACTIVE_COF,
      position: centerPos,
      camera: camera,
    );
    add(step);
    planController.currentActiveStep = step;
    planController.componentsInGame.add(step);

    TextComponent textStep = TextBoxStep(
        activeStep.name,
        centerPos,
        activeStep.background,
        Vector2(step.width, step.height),
        TEXT_BOX_FONT_SIZE_ACTIVE_STEP);
    add(textStep);
    planController.componentsInGame.add(textStep);
  }

  List<StepModel> getLastSteps(StepModel step) {
    if (step.parentId == 0) {
      return [];
    } else {
      return [planController.getStepById(step.parentId)];
    }
  }

  List getNextSteps(StepModel step) {
    return step.childs;
  }

  void drawLastSteps(List lastSteps) {
    List<List<double>> listPos = planController.getPositionLastSteps(
        lastSteps.length, canvasSize.x, canvasSize.y);
    StepRectangleFrontPage currentActStep = planController.currentActiveStep;

    for (int i = 0; i < lastSteps.length; i++) {
      var step = lastSteps[i];
      var pos = listPos[i];
      double stepW = step.width / STEP_DECREASE_CHILD_COF;
      double stepH = step.height / STEP_DECREASE_CHILD_COF;
      Vector2 position = Vector2(pos[0] - stepW / 2, pos[1] - stepH / 2);

      StepRectangleFrontPage newStep = StepRectangleFrontPage(
        id: step.id,
        squareWidth: step.width / STEP_DECREASE_CHILD_COF,
        squareHeight: step.height / STEP_DECREASE_CHILD_COF,
        position: position,
        camera: camera,
      );
      add(newStep);
      planController.componentsInGame.add(newStep);

      Vector2 posStart = getPosLineStart({
        'width': stepW,
        'height': stepH,
        'type': step.type // TODO add check by type
      }, position);

      Vector2 posEnd = getPosLineEnd(
        {'width': stepW, 'type': step.type},
        position,
        currentActStep.position,
      );

      double difParentChildHeight = currentActStep.height - stepH;
      StepLine stepLine = StepLine(
        positionStart: posStart,
        positionEnd: Vector2(posEnd.x, posEnd.y + difParentChildHeight / 2),
      );
      add(stepLine);
      planController.componentsInGame.add(stepLine);

      TextComponent textStep = TextBoxStep(step.name, position, step.background,
          Vector2(stepW, stepH), TEXT_BOX_FONT_SIZE_LAST_NEXT_STEP);

      add(textStep);
      planController.componentsInGame.add(textStep);
    }
  }

  void drawNextSteps(List nextSteps) {
    List<List<double>> listPos = planController.getPositionNextSteps(
        nextSteps.length, canvasSize.x, canvasSize.y);
    StepRectangleFrontPage currentActStep = planController.currentActiveStep;

    for (int i = 0; i < nextSteps.length; i++) {
      var step = nextSteps[i];
      var pos = listPos[i];
      double stepW = step.width / STEP_DECREASE_CHILD_COF;
      double stepH = step.height / STEP_DECREASE_CHILD_COF;
      Vector2 position = Vector2(pos[0] - stepW / 2, pos[1] - stepH / 2);

      StepRectangleFrontPage newStep = StepRectangleFrontPage(
        id: step.id,
        squareWidth: stepW,
        squareHeight: stepH,
        position: position,
        camera: camera,
      );
      add(newStep);
      planController.componentsInGame.add(newStep);

      Vector2 posStart = getPosLineStart({
        'width': currentActStep.squareWidth,
        'height': currentActStep.squareHeight,
        'type': step.type // TODO add check by type
      }, currentActStep.position);
      Vector2 posEnd = getPosLineEnd(
        {'width': currentActStep.width, 'type': step.type},
        currentActStep.position,
        position,
      );

      double difParentChildHeight = currentActStep.height - stepH;
      StepLine stepLine = StepLine(
        positionStart: posStart,
        positionEnd: Vector2(posEnd.x, posEnd.y - difParentChildHeight / 2),
      );
      add(stepLine);
      planController.componentsInGame.add(stepLine);

      TextComponent textStep = TextBoxStep(step.name, position, step.background,
          Vector2(stepW, stepH), TEXT_BOX_FONT_SIZE_LAST_NEXT_STEP);

      add(textStep);
      planController.componentsInGame.add(textStep);
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    if (overlays.isActive('buttonActivate') && !info.handled) {
      overlays.remove('buttonActivate');
    }
    if (overlays.isActive('stepInfo') && !info.handled) {
      overlays.remove('stepInfo');
    }
    if (!info.handled) {
      planController.deleteCurrentStepBorder();
    }

    // print('widget----${info.eventPosition.widget}');
    // print('global---${info.eventPosition.global}');
    // print('game---${info.eventPosition.game}');
    // print('camera.position gg ---- ${camera.position}');
    // print('canvas x y === ${canvasSize.x} ${canvasSize.y}');
  }
}

class Plug extends PositionComponent {}
